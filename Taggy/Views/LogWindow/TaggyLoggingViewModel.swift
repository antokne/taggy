//
//  TaggyLoggingViewModel.swift
//  Taggy
//
//  Created by Antony Gardiner on 16/05/23.
//

import Foundation
import Combine
import SwiftUI

class TaggyLoggingViewModel: ObservableObject {
	@Published var textLog = ""
	@Published var highlightedText = ""
	
	private var dateFormatter = DateFormatter()
	
	private var messageCancellable: AnyCancellable?
	
	init() {
		messageCancellable = AGTaggyManager.shared.collector.$message
			.receive(on: RunLoop.main)
			.sink { [weak self] message in
				self?.appendMessage(message: message)
			}
		
		dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
		
		appendMessage(message: "Taggy Started.")
	}
	
	private func appendMessage(message: String) {
		guard message.count > 0 else {
			return
		}
		let logMessage = String(format: "%@: %@\n" , dateFormatter.string(from: Date()), message)
		textLog += logMessage
		
		let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)

		guard let bundleId = Bundle.mainBundleId else {
			return
		}

		let dir = URL(fileURLWithFileSystemRepresentation: bundleId, isDirectory: true, relativeTo: caches.first)
		try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
		
		let logFile = URL(fileURLWithFileSystemRepresentation: "\(Date())-taggy.log", isDirectory: false, relativeTo: dir)

		
		try? textLog.write(toFile: logFile.path, atomically: true, encoding: .utf8)		
	}
	
}
