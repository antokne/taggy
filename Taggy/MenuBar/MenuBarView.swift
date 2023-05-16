//
//  MenuBarView.swift
//  Taggy
//
//  Created by Antony Gardiner on 16/05/23.
//

import SwiftUI
import CoreData

struct MenuBarView: View {
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.openWindow) var openWindow

	@ObservedObject var viewModel: AGContentViewModel

	@State private var showingFailedToStartAlert = false

	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
		animation: .default)
	private var tags: FetchedResults<Tag>
	
	var body: some View {
		VStack() {
	
			ForEach(tags) { tag in
				HStack {
					Button {
						// do something...
						NotificationCenter.default.post(name: NSNotification.SelectTagNotification,
														object: nil, userInfo: ["tag": tag])
					} label: {
						HStack {
							Text(tag.emoji ?? "")
							Text(tag.name ?? "")
							Spacer()
							if let latestlocation = viewModel.mostRecentLocation(tag: tag, context: viewContext) {
								Text("\(latestlocation.dateString) \(latestlocation.timeString)")
							}
							Label("", systemImage: "arrow.right.circle")
						}
					}
					.buttonStyle(.borderless)
				}
			}
			
			Divider()
			
			HStack() {
				Button {
					showingFailedToStartAlert = !viewModel.playPause()
				} label: {
					Label(viewModel.isCollecting ? "Stop":  "Start",
						  systemImage: viewModel.isCollecting ? "stop.circle.fill":  "record.circle")
				}
				Button(action: openFindMy) {
					Text("Open FindMy...")
				}
				Spacer()
			}
		}
		.failedToStartAlert(isPresented: $showingFailedToStartAlert)
		.padding(5)
	}
		
}

struct MenuBarView_Previews: PreviewProvider {
	static var previews: some View {
		MenuBarView(viewModel: AGContentViewModel())
	}
}
