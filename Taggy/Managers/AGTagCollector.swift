//
//  AGTagCollector.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import Foundation
import AGCore
import Combine


/// Protocol to use to create new collectors.
protocol AGTagCollectorProtocol {
	/// Enable collectiing
	/// - Parameter rateMin: minutes between collection
	func startCollectingImpl(rate rateMin: Int) -> Bool
	func stopCollectingImpl()
	
	var notifyStatusDelegate: AGTagNotifyStatusProcotol? { get set }
}

protocol AGTagNotifyStatusProcotol {
	func notifiyStatusMessage(message: String)
}

public class AGTagCollector {
		
	private var messageHandler: MessageHandler?
	
	public static let TagCollectingRateMinuteName = "TagCollectingRate"

	public static let shared: AGTagCollector = AGTagCollector()
	
	@Published public var isCollecting: Bool = false
	@Published public var message: String = ""
		
	private let collectingRateValue = AGUserDefaultDoubleValue(keyName: TagCollectingRateMinuteName, defaultValue: 1)

	let collectors:[AGTagCollectorProtocol] = [AGTagCollectorFindMyItems()]

	
	init() {
		self.messageHandler = MessageHandler(messageForwarder: self)
	}

	@discardableResult
	func startCollecting() -> Bool {
		isCollecting = true
		for var collector in collectors {
			isCollecting = collector.startCollectingImpl(rate: Int(collectingRateValue.doubleValue))
			collector.notifyStatusDelegate = self
		}
		
		if !isCollecting {
			stopCollecting()
		}
		else {
			Task {
				await messageHandler?.addMessage(message: "Collecting started...")
			}
		}
		return isCollecting
	}
	
	func stopCollecting() {
		isCollecting = false
		for var collector in collectors {
			collector.notifyStatusDelegate = nil
			collector.stopCollectingImpl()
		}
		Task {
			await messageHandler?.addMessage(message: "Collecting stopped.")
		}
	}
}

extension AGTagCollector: AGTagNotifyStatusProcotol {
	
	func notifiyStatusMessage(message: String) {
		Task {
			await messageHandler?.addMessage(message:message)
		}
	}
}

extension AGTagCollector: AGMessageForwardMessageProtocol {
	func formwardMessage(message: String) {
		self.message = message
	}
}

protocol AGMessageForwardMessageProtocol {
	func formwardMessage(message: String)
}

private actor MessageHandler {

	private var messageList: [String] = []

	var messageTimer: Timer?
	
	private var messageForwarder: AGMessageForwardMessageProtocol
	
	init(messageForwarder: AGMessageForwardMessageProtocol) {
		self.messageForwarder = messageForwarder
	}
	
	func createMessageTimer() {

		guard messageTimer == nil else {
			return
		}
		
		self.messageTimer = Timer(timeInterval: 2.0, repeats: true) { [weak self] timer in
			
			guard let self else {
				return
			}
			
			Task { @MainActor in
				await self.processMessageStack()
			}
		}
		
		if let messageTimer {
			RunLoop.main.add(messageTimer, forMode: .common)
		}
	}
	
	func addMessage(message: String) {
		createMessageTimer()
		messageList.append(message)
	}
	
	func removeNextMessage() -> String? {
		guard !messageList.isEmpty else {
			return ""
		}
		return messageList.removeFirst()
	}
	
	func processMessageStack() async {
				
		// check for empty before we send
		if messageList.isEmpty {
			messageTimer?.invalidate()
			messageTimer = nil
		}

		// send message
		if let nextMessage = removeNextMessage() {
			messageForwarder.formwardMessage(message: nextMessage)
		}

	}
}
