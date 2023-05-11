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
		
	private var messageHandler = MessageHandler()
	
	public static let TagCollectingRateMinuteName = "TagCollectingRate"

	public static let shared: AGTagCollector = AGTagCollector()
	
	@Published public var isCollecting: Bool = false
	@Published public var message: String = ""
	
	
	private let collectingRateValue = AGUserDefaultDoubleValue(keyName: TagCollectingRateMinuteName)

	let collectors:[AGTagCollectorProtocol] = [AGTagCollectorFindMyItems()]

	var messageTimer: Timer?
	
	init() {
	}

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
				await messageHandler.addMessage(message: "Collecting started.")
			}
			
			createTimer()
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
			await messageHandler.addMessage(message: "Collecting stopped.")
		}
	}
	
	func createTimer() {
		messageTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] timer in
			
			guard let self else {
				return
			}
			
			Task { @MainActor in
				await self.processMessageStack()
			}
		}
	}
	
	func processMessageStack() async {
		if let nextMessage = await messageHandler.getMessage() {
			message = nextMessage
		}
	}
}

extension AGTagCollector: AGTagNotifyStatusProcotol {
	
	func notifiyStatusMessage(message: String) {
		Task {
			await messageHandler.addMessage(message:message)
		}
	}
}

private actor MessageHandler {

	private var messageList: [String] = []

	func addMessage(message: String) {
		messageList.append(message)
	}
	
	func getMessage() -> String? {
		guard !messageList.isEmpty else {
			return ""
		}
		return messageList.removeFirst()
	}
}
