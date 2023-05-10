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
//				ForEach(tags) { tag in
//					NavigationLink(tag: tag, selection: $selectedTag) {
//						let _ = print("selected tag = \(selectedTag)")
//						let fetchRequest = FetchRequest(fetchRequest: Location.sortedFetchRequest(tag: tag))
//						AGLocationListView(locations: fetchRequest)
//					} label: {
//						HStack {
//							Text(tag.emoji ?? "")
//							Text(tag.name ?? "")
//						}
//					}
					
				//let _ = print("selected = \(selectedTag)")
					NavigationLink(value: tag) {
						HStack {
							Text(tag.emoji ?? "")
							Text(tag.name ?? "")
						}
					}
//				}
			}
			.navigationTitle("Tags")
			.onDeleteCommand(perform: deleteItems)
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
				//let _ = print("for map selected = \(selectedTag)")
//				Text("\(selectedTag)")
				AGMapView(viewModel: AGMapViewModel(tag: selectedTag))
			}
		}
	}

	private func selectFile() {
		NSOpenPanel.openImage { (result) in
			if case let .success(url) = result {
				print(url)
				
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
		print(isCollecting)
	}
	
//	private func addItem() {
//		withAnimation {
//			let newItem = Item(context: viewContext)
//			newItem.timestamp = Date()
//
//			do {
//				try viewContext.save()
//			} catch {
//				// Replace this implementation with code to handle the error appropriately.
//				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//				let nsError = error as NSError
//				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//			}
//		}
//	}
	
	private func deleteItems() {
		if let selectedTag {
			viewContext.delete(selectedTag)
			try? viewContext.save()
			self.selectedTag = nil
		}
	}
		
	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			offsets.map { tags[$0] }.forEach(viewContext.delete)
			
			do {
				try viewContext.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}
}

private let itemFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .short
	formatter.timeStyle = .medium
	return formatter
}()

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}


extension NSOpenPanel {
	
	static func openImage(completion: @escaping (_ result: Result<URL, Error>) -> ()) {
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseFiles = true
		panel.canChooseDirectories = false
		panel.allowedFileTypes = ["jpg", "jpeg", "png", "fit", "data"]
		panel.canChooseFiles = true
		panel.begin { (result) in
			if result == .OK,
			   let url = panel.urls.first {
				completion(.success(url))
			} else {
				completion(.failure(
					NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get file location"])
				))
			}
		}
	}
}
