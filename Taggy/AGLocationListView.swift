//
//  AGLocationListView.swift
//  Taggy
//
//  Created by Antony Gardiner on 10/05/23.
//

import SwiftUI

struct AGLocationListView: View {
	
	@FetchRequest var locations: FetchedResults<Location>
	
	@State private var selectedLocations = Set<Location.ID>()
	
	var body: some View {
		VStack{
			Table(locations, selection: $selectedLocations) {
				TableColumn("Date", value: \Location.dateString)
					.width(70)
				TableColumn("Time", value: \Location.timeString)
					.width(50)
				TableColumn("Latitude", value: \Location.latitudeString)
					.width(60)
				TableColumn("Longitude", value: \Location.longitudeString)
					.width(60)
				// TableColumn("Tag", value: \AGLocationData.tagName)
			}
			Text("\(selectedLocations.count) locations selected")
		}
	}
}

struct AGLocationListView_Previews: PreviewProvider {
	static var previews: some View {
		let fetchRequest = FetchRequest(fetchRequest: Location.sortedFetchRequest())
		AGLocationListView(locations: fetchRequest)
	}
}
