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
		ScrollView {
			Text("Taggy needs full disk access to be able to access the FindMy Files.")
				.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
			Text("")
			Text("Please perform the following 3 steps:")
			
			Section {
				Text("1. Open settings and go into Pravicy & Security, Full Disk Access, and enable Taggy.")
				
				Button("Open Settings...") {
					openSystemSettings()
				}
				Text("(An app restart is required.)")
					.font(.caption2.italic())
				Image("fulldisk access")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(minWidth: 600)
				
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
		.failedToStartAlert(isPresented: $showingFailedToStartAlert)
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
