//
//  ContentView.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
	@Environment(\.managedObjectContext) private var viewContext
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
		animation: .default)
	private var tags: FetchedResults<Tag>
	
	@State private var dragOver = false
	@State private var selectedTag: Tag?
	@State private var isCollecting = AGTaggyManager.shared.collector.isCollecting
	@State private var mapTag: Tag?
	@State private var showWelcomeView: Bool = false

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
						Label(isCollecting ? "Start" : "Stop", systemImage: isCollecting ? "stop.circle.fill":  "record.circle")
					}
					Button(action: openFindMy) {
						Text("Open FindMy...")
					}
					Button("?") {
						showWelcomeView = true
					}
					.popover(isPresented: $showWelcomeView, arrowEdge: .bottom) {
						AGWelcomeView()
					}
				}
			}
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
	}

	private func openFindMy() {
		NSWorkspace.shared.open(URL(string: "findmy://")!)
	}
	
	private func playPause() {
		if isCollecting {
			AGTaggyManager.shared.collector.stopCollecting()
		}
		else {
			AGTaggyManager.shared.collector.startCollecting()
		}
		isCollecting = AGTaggyManager.shared.collector.isCollecting
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

