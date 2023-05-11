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
	@State var coordinateRegion: MKCoordinateRegion

	init(viewModel: AGMapViewModel) {
		self.viewModel = viewModel
		self.boundingRect = viewModel.boundingRect
		self.coordinateRegion = viewModel.coordinateRegion
	}
	
	var body: some View {
//		let _ = print("viewModel.boundingRect = \(viewModel.boundingRect)")
//		let _ = print("self.boundingRect = \(self.boundingRect)")
//		Map(mapRect: $boundingRect, interactionModes: .all, annotationItems: viewModel.points) { point in
//			MapAnnotation(coordinate: point.location) {
//				Circle().stroke(Color.blue)
//					.frame(width: 20, height: 20)
//			}
//		}

		//let _ = print("self.coordinateRegion = \(self.coordinateRegion)")
		Map(coordinateRegion: $coordinateRegion, interactionModes: .all, annotationItems: viewModel.points) { point in
			MapAnnotation(coordinate: point.location) {
				Circle().stroke(Color.blue)
					.frame(width: 20, height: 20)
			}
		}

		HStack {
			Button("Reset") {
				self.coordinateRegion = viewModel.coordinateRegion
			}
			Button("+") {
				self.coordinateRegion.span.longitudeDelta *= 0.25
				self.coordinateRegion.span.latitudeDelta *= 0.25
			}
			Button("-") {
				var tempCoordRegion = self.coordinateRegion
				
				tempCoordRegion.span.longitudeDelta /= 0.25
				tempCoordRegion.span.latitudeDelta /= 0.25
				
				if tempCoordRegion.span.longitudeDelta < 180 && tempCoordRegion.span.latitudeDelta < 90 {
					self.coordinateRegion = tempCoordRegion
				}
				
			}
		}
		.frame(height: 20)
		.padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
	}
}

struct AGMappView_Previews: PreviewProvider {
	static var previews: some View {
		AGMapView(viewModel: AGMapViewModel())
	}
}
