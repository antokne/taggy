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
			.receive(on: RunLoop.main)
			.sink { [weak self] isCollecting in
				self?.isCollecting = isCollecting
			}

		messageCancellable = AGTaggyManager.shared.collector.$message
			.receive(on: RunLoop.main)
			.sink { [weak self] message in
				self?.message = message
		}
	}
}
