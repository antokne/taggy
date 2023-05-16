//
//  AGWelcomeView.swift
//  Taggy
//
//  Created by Antony Gardiner on 10/05/23.
//

import SwiftUI

struct TaggyWelcomeView: View {
	@State private var showingFailedToStartAlert = false
	var body: some View {
		NavigationStack {
			List {
				
				Text("In order for Taggy to work it needs full access to disk. Even though it only reads one file.")
				Text("")
				Text("Please perform the following 3 steps:")
				
				Section {
					Text("1. Open settings and go into Pravicy & Security, Full Disk Access, and enable for Taggy.")
					
					Button("Open Settings...") {
						openSystemSettings()
					}
					
					Image("fulldisk access")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 551, height: 300)
					
				}
				
				Section() {
					
					Text("2. Open Find My App.")
					
					Button("Open Find My...") {
						openFindMy()
					}
				}
								
				Section {
					Text("3. Start recording.")
					
					Button(action: startRecording) {
						Label("Start", systemImage: "record.circle")
					}
				}
				
				Text("Note that the Find My App needs to be running whilst collecting location information.")
					.font(.title3.bold().italic())
			}
		}
		.alert(isPresented: $showingFailedToStartAlert) {
			FailedToStartAlertView
		}
	}
	
	func startRecording() {
		let result = AGTaggyManager.shared.collector.startCollecting()
		if result == false {
			showingFailedToStartAlert = true
		}
	}
}

struct AGWelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		TaggyWelcomeView()
	}
}
