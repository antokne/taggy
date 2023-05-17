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
		loadCurrentLog()
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
		

		guard let logFileURL = logFileURL() else {
			return
		}
		
		try? textLog.write(toFile: logFileURL.path, atomically: true, encoding: .utf8)		
	}
	
	func loadCurrentLog() {
		guard let logFileURL = logFileURL() else {
			return
		}
		
		do {
			let logContents = try String(contentsOf: logFileURL)
			textLog = logContents
		}
		catch {
			// silently failing is not great.
			// we just end up creating a new log so not the end of the world I think.
		}
	}
	
	func logFileURL() -> URL? {
		
		let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
		
		guard let bundleId = Bundle.mainBundleId else {
			return nil
		}
		
		let dir = URL(fileURLWithFileSystemRepresentation: bundleId, isDirectory: true, relativeTo: caches.first)
		try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyy-MM-dd"
		let dateString = dateFormatter.string(from: Date())
		
		let logFile = URL(fileURLWithFileSystemRepresentation: "\(dateString)-taggy.log", isDirectory: false, relativeTo: dir)
		
		return logFile
	}
	
}
