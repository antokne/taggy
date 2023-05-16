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

public func openSystemSettings() {
	if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") {
		NSWorkspace.shared.open(url)
	}
}

let FailedToStartAlertView = Alert(title: Text("Failed to start monitoring Find My Data"),
								   message: Text("Please check in System Settings -> Privacy & Security -> Full Disk Access that Taggy access is enabled. \nThen try again."),
								   dismissButton: .default(Text("OK")))


public struct FailedToStartAlert: ViewModifier {
	var isPresented: Binding<Bool>
	
	public func body(content: Content) -> some View {
		content
			.alert("Failed to start monitoring Find My Data",
				   isPresented: isPresented,
				   actions: {
				Button("OK", action: {})
				Button("Open Settings", action: { openSystemSettings() })
			}, message: {
				Text("Please check in System Settings -> Privacy & Security -> Full Disk Access that Taggy access is enabled. \nThen try again.")
			})
	}
}

extension View {
	public func failedToStartAlert(isPresented: Binding<Bool>) -> some View {
		self.modifier(FailedToStartAlert(isPresented: isPresented))
	}
}
