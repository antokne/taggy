//
//  AGLocationListView.swift
//  Taggy
//
//  Created by Antony Gardiner on 10/05/23.
//

import SwiftUI

struct AGLocationListView: View {
	@Environment(\.managedObjectContext) private var viewContext

	var tag: Tag?
	@FetchRequest var locations: FetchedResults<Location>
	
	@Binding var selectedLocations: [Location]

	@State private var selectedLocationIds = Set<Location.ID>()
	
	var body: some View {
		VStack{
			Table(locations, selection: $selectedLocationIds) {
				TableColumn("Date", value: \Location.dateString)
					.width(ideal: 70)
				TableColumn("Time", value: \Location.timeString)
					.width(ideal: 50)
				TableColumn("Latitude", value: \Location.latitudeString)
					.width(ideal: 60)
				TableColumn("Longitude", value: \Location.longitudeString)
					.width(ideal: 60)
			}
			.onChange(of: selectedLocationIds) { newSelectedIds in
				generateLocationsListFromSelected()
			}
			HStack {
				if selectedLocationIds.count > 0 {
					Button("Clear Selection") {
						selectedLocationIds.removeAll()
					}
				}
				Text("\(selectedLocationIds.count) locations selected")
				Spacer()
				if let tag {
					Text(String(format:"%.2f  pings/hr", Location.calculatePingRate(tag: tag, context: viewContext) * 60.0 * 60.0))
				}
			}
			.frame(height: 20)
			.padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
		}
	}
	
	func generateLocationsListFromSelected() {
		self.selectedLocations = locations.filter { location in selectedLocationIds.contains(where: { location.id == $0 })  }
	}
}

struct AGLocationListView_Previews: PreviewProvider {
	static var previews: some View {
		@State var selectedLocations: [Location] = []
		let fetchRequest = FetchRequest(fetchRequest: Location.sortedFetchRequest())
		AGLocationListView(locations: fetchRequest, selectedLocations: $selectedLocations)
	}
}
