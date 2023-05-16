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
	
	@AppStorage(TaggyGeneralSettingsViewModel.TagShowMenuBarExtraName) private var showMenuBarExtra = true
	@AppStorage(TaggyGeneralSettingsViewModel.TagStartRecordingOnOpenName) private var startRecordingOnOpen = false

	var viewModel = AGContentViewModel()
	
	// Initing the log view model here so it's not created multiple times...
	var logViewModel = TaggyLoggingViewModel()
	
	var body: some Scene {
				
		WindowGroup {
			ContentView(viewModel: viewModel, mainView: true)
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
		
		Window("Welcome to Taggy", id: TaggyWelcomeWindowName) {
			TaggyWelcomeView()
		}
		.keyboardShortcut("T", modifiers: [.command])

		Window("Taggy Log", id: TaggyLogWindowName) {
			TaggyLoggingView(viewModel: logViewModel)
		}
		.keyboardShortcut("L", modifiers: [.command])
		
		MenuBarExtra("Taggy", image: "custom.tag", isInserted: $showMenuBarExtra) {
			MenuBarView(viewModel: viewModel)
				.environment(\.managedObjectContext, taggyManager.persistenceController.container.viewContext)
		}
		.menuBarExtraStyle(.window)
	}
	
	private func onActive() {
		
		taggyManager.updateController.startUpdater()
		
		var showWelcomeScreen = AGUserDefaultBoolValue(keyName: "showWelcomeScreen")
		if showWelcomeScreen.boolValue == false {
			openWelcomeWindow(openWindow: openWindow)
			showWelcomeScreen.boolValue = true
		}
		
		if startRecordingOnOpen {
			taggyManager.collector.startCollecting()
		}
	}
	

}
