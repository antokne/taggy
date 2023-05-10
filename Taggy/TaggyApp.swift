//
//  TaggyApp.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import SwiftUI

@main
struct TaggyApp: App {
	@Environment(\.scenePhase) var scenePhase
	let taggyManager = AGTaggyManager()
	
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
				//taggyManager.collector.startCollecting()
				break
			default:
				break
			}
		}
	}
}
