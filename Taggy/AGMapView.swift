//
//  AGMapView.swift
//  Taggy
//
//  Created by Antony Gardiner on 10/05/23.
//

import SwiftUI
import MapKit

struct AGMapView: View {
	
	var viewModel: AGMapViewModel
	
	@State var boundingRect: MKMapRect
	
	init(viewModel: AGMapViewModel) {
		self.viewModel = viewModel
		self.boundingRect = viewModel.boundingRect
	}
	
	var body: some View {
//		if viewModel.locations.count == 0 {
//			Text("Select an item")
//		}
//		else {
			Map(mapRect: $boundingRect, annotationItems: viewModel.points) { point in
				MapAnnotation(coordinate: point.location) {
					Circle().stroke(Color.blue)
						.frame(width: 20, height: 20)
				}
			}
			
				
				
//		}
	
	}
}

//struct AGMappView_Previews: PreviewProvider {
//	static var previews: some View {
//		let fetchRequest = FetchRequest(fetchRequest: Location.sortedFetchRequest())
//		AGMapView(locations: fetchRequest)
//	}
//}
