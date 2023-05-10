//
//  AGMapViewModel.swift
//  Taggy
//
//  Created by Antony Gardiner on 10/05/23.
//

import Foundation
import Combine
import SwiftUI
import MapKit

struct IdentifiablePoint: Identifiable {
	let id: UUID
	let location: CLLocationCoordinate2D
	init(id: UUID = UUID(), location: CLLocationCoordinate2D) {
		self.id = id
		self.location = location
	}
}

class AGMapViewModel: ObservableObject {
	
	var tag: Tag?
	
	private(set) var locations: [Location] = []

	var boundingRect: MKMapRect = MKMapRect()

	init(tag: Tag? = nil) {
		
		self.tag = tag
		let fetchRequest = Location.sortedFetchRequest(tag: tag)
		do {
			self.locations = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
			self.boundingRect = self.polyline.boundingMapRect
		}
		catch {
			
		}
	}
	
	
	var points: [IdentifiablePoint] {
		locationCoodinates.map { IdentifiablePoint(location: $0) }
	}
	
	lazy var locationCoodinates: [CLLocationCoordinate2D] = {
		locations.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
	}()
	
	
	lazy var mapPoints: [MKMapPoint] = {
		locationCoodinates.map { MKMapPoint($0) }
	}()
	
	lazy var polyline: MKPolyline = {
		MKPolyline(coordinates: locationCoodinates, count: locationCoodinates.count)
	}()
	
	
}
