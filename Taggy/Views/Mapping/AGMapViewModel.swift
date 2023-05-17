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
	
	@AppStorage(TaggyGeneralSettingsViewModel.TagShowLineOnMapName) var showLineOnMap = false

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
		let unionRect = mapPoints.reduce(MKMapRect.null) { rect, point in
			let newRect = MKMapRect(origin: point, size: MKMapSize())
			return rect.union(newRect)
		}
		
		return MKCoordinateRegion(unionRect)
	}
	
	var annotations: [MKAnnotation] {
		locationCoodinates.map { TaggyAnnotation(coordinate: $0, emoji: tag?.emoji) }
	}
	
	private var configurationBlue = NSImage.SymbolConfiguration(paletteColors: [.systemBlue])
	private var configurationDarkBlue = NSImage.SymbolConfiguration(paletteColors: [NSColor(red: 0, green: 0, blue: 0.5, alpha: 1)])

	func symbolConfiguration(for lastLocation: Bool? = false) -> NSImage.SymbolConfiguration {
		if let lastLocation, lastLocation == true {
			return configurationDarkBlue
		}
		else {
			return configurationBlue
		}
	}
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

extension Location {
	var coordinate: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
}

extension CLLocationCoordinate2D: Equatable {
	public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}
	
	
}
