//
//  AGContentViewModel.swift
//  Taggy
//
//  Created by Antony Gardiner on 11/05/23.
//

import Foundation
import SwiftUI
import Combine

class AGContentViewModel: ObservableObject {
	
	@Published public var isCollecting: Bool = false
	@Published public var message: String = ""
	
	var isCollectingCancellable: AnyCancellable?
	var messageCancellable: AnyCancellable?

	
	
	init() {

		isCollectingCancellable = AGTaggyManager.shared.collector.$isCollecting
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isCollecting in
				if self?.isCollecting != isCollecting {
					self?.isCollecting = isCollecting
				}
			}

		messageCancellable = AGTaggyManager.shared.collector.$message
			.receive(on: DispatchQueue.main)
			.sink { [weak self] message in
				
				if self?.message != message {
					self?.message = message
				}
		}
	}
	
	public func playPause() -> Bool {
		if AGTaggyManager.shared.collector.isCollecting {
			AGTaggyManager.shared.collector.stopCollecting()
			return true
		}

		return AGTaggyManager.shared.collector.startCollecting()
	}
	
	func mostRecentLocation(tag: Tag, context: NSManagedObjectContext) -> Location? {
		Location.findLocation(tag: tag, context: context)
	}
	
}

extension NSNotification {
	static let SelectTagNotification = Notification.Name.init("SelectTagNotification")
}
