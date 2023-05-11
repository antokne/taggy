//
//  TaggyApp.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import SwiftUI
import AGCore

@main
struct TaggyApp: App {
	@Environment(\.scenePhase) var scenePhase
	@Environment(\.openWindow) var openWindow

	let taggyManager = AGTaggyManager.shared
	
	var body: some Scene {
				
		WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, taggyManager.persistenceController.container.viewContext)
		}
		.onChange(of: scenePhase) { newPhase in
			taggyManager.persistenceController.save()
			
			switch newPhase {
			case .background:
				break
			case .active:
				onActive()
				break
			default:
				break
			}
		}
		.commands {
			CommandGroup(after: .appInfo) {
				TaggyCheckForUpdatesView(updater: taggyManager.updateController.updater)
			}
		}
		
		Settings {
			TaggyPreferencesView()
		}
		
		Window("Welcome to Taggy", id: "taggy-welcome-window") {
			AGWelcomeView()
		}
	}
	
	private func onActive() {
		
		taggyManager.updateController.startUpdater()
		
		var showWelcomeScreen = AGUserDefaultBoolValue(keyName: "showWelcomeScreen")
		if showWelcomeScreen.boolValue == false {
			openWelcome()
			showWelcomeScreen.boolValue = true
		}
	}
	
	private func openWelcome() {
		Task { @MainActor in
			openWindow(id: "taggy-welcome-window")
		}
	}
}
