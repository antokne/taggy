//
//  TaggySharedViews.swift
//  Taggy
//
//  Created by Antony Gardiner on 16/05/23.
//

import Foundation
import SwiftUI

public let TaggyWelcomeWindowName = "taggy-welcome-window"
public let TaggyLogWindowName = "taggy-log-window"

extension View {
	public func openWelcomeWindow(openWindow: OpenWindowAction) {
		internal_openWelcomeWindow(openWindow: openWindow)
	}
	
	public func openLogWindow(openWindow: OpenWindowAction) {
		openWindow(id: TaggyLogWindowName)
	}
}

extension App {
	public func openWelcomeWindow(openWindow: OpenWindowAction) {
		Task { @MainActor in
			internal_openWelcomeWindow(openWindow: openWindow)
		}
	}
}

private func internal_openWelcomeWindow(openWindow: OpenWindowAction) {
	openWindow(id: TaggyWelcomeWindowName)
}


public func openFindMy() {
	NSWorkspace.shared.open(URL(string: "findmy://")!)
}


let FailedToStartAlertView = Alert(title: Text("Failed to start monitoring Find My Data"),
								   message: Text("Please check in System Settings -> Privacy & Security -> Full Disk Access that Taggy access is enabled. \nThen try again."),
								   dismissButton: .default(Text("OK")))
