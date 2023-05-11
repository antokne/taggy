//
//  ContentView.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import SwiftUI
import CoreData
import AGCore

struct ContentView: View {
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.openWindow) var openWindow

	@State private var showingFailedToStartAlert = false

	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
		animation: .default)
	private var tags: FetchedResults<Tag>
	
	@State private var dragOver = false
	@State private var selectedTag: Tag?
	@State private var mapTag: Tag?
	@State private var showWelcomeView: Bool = false
	
	@ObservedObject var viewModel = AGContentViewModel()

	var body: some View {
		NavigationSplitView {
			List(tags, selection: $selectedTag) { tag in
				NavigationLink(value: tag) {
					HStack {
						Text(tag.emoji ?? "")
						Text(tag.name ?? "")
					}
				}
			}
			.navigationTitle("Tags")
			.onDeleteCommand(perform: deleteItem)
			.toolbar {
				ToolbarItemGroup {
					Button(action: playPause) {
						Label("", systemImage: viewModel.isCollecting ? "stop.circle.fill":  "record.circle")
					}
					Button(action: openFindMy) {
						Text("Open FindMy...")
					}
					Button("?") {
						openWelcome()
					}
				}
			}
			
			HStack {
				Text(viewModel.message)
				Spacer()
			}
			.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
			.frame(height: 20)
			
		} content: {
			if let selectedTag {
				let fetchRequest = FetchRequest(fetchRequest: Location.sortedFetchRequest(tag: selectedTag))
				AGLocationListView(locations: fetchRequest)
			}
			else {
				Text("Select a Tag")
			}
		} detail: {
			if let selectedTag {
				AGMapView(viewModel: AGMapViewModel(tag: selectedTag))
			}
		}
		.alert(isPresented: $showingFailedToStartAlert) {
			FailedToStartAlertView
		}

	}
	
	private func openFindMy() {
		NSWorkspace.shared.open(URL(string: "findmy://")!)
	}
	
	private func openWelcome() {
		openWindow(id: "taggy-welcome-window")
	}
	
	private func playPause() {
		if AGTaggyManager.shared.collector.isCollecting {
			AGTaggyManager.shared.collector.stopCollecting()
		}
		else {
			if !AGTaggyManager.shared.collector.startCollecting() {
				showingFailedToStartAlert = true
			}
		}
	}
	
	private func deleteItem() {
		if let selectedTag {
			viewContext.delete(selectedTag)
			try? viewContext.save()
			self.selectedTag = nil
		}
	}

}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}

