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

extension IdentifiablePoint: Equatable {
	static func == (lhs: IdentifiablePoint, rhs: IdentifiablePoint) -> Bool {
		lhs.location.latitude == rhs.location.latitude &&
		lhs.location.longitude == rhs.location.longitude
	}
}

public class AGMapViewModel: NSObject, ObservableObject {
	
	var tag: Tag?
	
	private(set) var locations: [Location] = []

	var boundingRect: MKMapRect = MKMapRect()

	init(tag: Tag? = nil, selectedLocations: [Location]? = nil) {
		self.tag = tag
		super.init()

		if let selectedLocations,
			selectedLocations.count > 0 {
			self.locations = Array(selectedLocations)
			self.boundingRect = self.polyline.boundingMapRect
			return
		}
		
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
	
	var locationCoodinates: [CLLocationCoordinate2D] {
		locations.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
	}
	
	
	var mapPoints: [MKMapPoint] {
		locationCoodinates.map { MKMapPoint($0) }
	}
	
	var polyline: MKPolyline {
		MKPolyline(coordinates: locationCoodinates, count: locationCoodinates.count)
	}
	
	var coordinateRegion: MKCoordinateRegion {
//		var union: MKMapRect? = nil
//		for point in mapPoints {
//			let rect = MKMapRect(origin: point, size: MKMapSize(width: 10, height: 10))
//
//			guard var union else {
//				union = rect
//				continue
//			}
//
//			union = union.union(rect)
//		}
		
		let unionRect = mapPoints.reduce(MKMapRect.null) { rect, point in
			let newRect = MKMapRect(origin: point, size: MKMapSize())
			return rect.union(newRect)
		}
		
		return MKCoordinateRegion(unionRect)
	}
	
	var annotations: [MKAnnotation] {
		locationCoodinates.map { TaggyAnnotation(coordinate: $0, emoji: tag?.emoji) }
	}
	
	var configuration = NSImage.SymbolConfiguration(paletteColors: [.systemBlue])

}


public class TaggyAnnotation : NSObject, MKAnnotation {

	public var emoji: String?
	public var coordinate: CLLocationCoordinate2D
	
	public init(coordinate: CLLocationCoordinate2D, emoji: String?) {
		self.coordinate = coordinate
		self.emoji = emoji
	}

	public var title: String? {
		nil
	}
}
