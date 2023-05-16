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
		
	@ObservedObject var viewModel: AGContentViewModel
	
	@State private var selectedLocations = [Location]()
	
	private var mainView = false
	
	init(viewModel: AGContentViewModel, mainView: Bool = false) {
		self.viewModel = viewModel
		self.mainView = mainView
	}
	
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
			.toolbar {
				ToolbarItemGroup {
					Button {
						showingFailedToStartAlert = !viewModel.playPause()
					} label: {
						Label("", systemImage: viewModel.isCollecting ? "stop.circle.fill":  "record.circle")
					}
					Button(action: openFindMy) {
						Text("Open FindMy...")
					}
					Button("?") {
						openWelcomeWindow(openWindow: openWindow)
					}
				}
			}
			.onReceive(NotificationCenter.default.publisher(for: NSNotification.SelectTagNotification)) { data in
				if mainView {
					guard let userInfo = data.userInfo, let tag = userInfo["tag"] as? Tag else {
						return
					}
					selectedTag = tag
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
				AGLocationListView(tag: selectedTag, locations: fetchRequest, selectedLocations: $selectedLocations)
			}
			else {
				Text("Select a Tag")
			}
		} detail: {
			if let selectedTag {
//				AGMapView(viewModel: AGMapViewModel(tag: selectedTag, selectedLocations: selectedLocations))
				TaggyMapWrapperView(viewModel: AGMapViewModel(tag: selectedTag, selectedLocations: selectedLocations))
			}
		}
		.failedToStartAlert(isPresented: $showingFailedToStartAlert)
		.onDeleteCommand(perform: deleteItem)

	}
	
	private func deleteItem() {
		if let selectedTag {
			let index = tags.firstIndex(of: selectedTag)

			viewContext.delete(selectedTag)
			try? viewContext.save()
			self.selectedTag = nil
			
			if let index, index >= 0, tags.count > 0 {
				if index < tags.count {
					self.selectedTag = tags[index]
				}
				else {
					self.selectedTag = tags.last
				}
			}
			else {
				self.selectedTag = nil
			}
		}
	}

}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(viewModel: AGContentViewModel())
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}

