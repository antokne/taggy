//
//  Location+CoreDataExtensions.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import Foundation

import CoreData
import AGCore

extension Location {
	
	class func sortedFetchRequest(tag: Tag? = nil) -> NSFetchRequest<Location> {
		let fetchRequest = NSFetchRequest<Location>(entityName: Location.className)
		var subPredicates: [NSPredicate] = []
		if let tag {
			subPredicates.append(\Location.tag == tag)
		}
		
		fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: subPredicates)
		let sortDescriptor = NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		return fetchRequest
	}
	
	class func findLocation(tag: Tag, timestamp: Date, context: NSManagedObjectContext) -> Location? {
		
		let fetchRequest = NSFetchRequest<Location>(entityName: Location.className)
		
		var subPredicates: [NSPredicate] = []

		subPredicates.append(\Location.tag == tag)
		subPredicates.append(\Location.timestamp == timestamp)
		fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: subPredicates)
				
		do {
			let result = try context.fetch(fetchRequest)
			return result.first
		}
		catch {
			return nil
		}
	}
	
	@discardableResult
	class func add(context: NSManagedObjectContext) -> Location {
		let newLocation = Location(context: context)
		return newLocation
	}
	
	@discardableResult
	func setAltitude(altitude: Int?) -> Location {
		if let altitude {
			self.altitude = Int32(altitude)
		}
		return self
	}
	
	@discardableResult
	func setFloor(floor: Int?) -> Location {
		if let floor {
			self.floor = Int16(floor)
		}
		return self
	}

	@discardableResult
	func setHorizontalAccuracy(horizontalAccuracy: Double?) -> Location {
		if let horizontalAccuracy {
			self.horizontalAccuracy = Int16(horizontalAccuracy)
		}
		return self
	}
	
	@discardableResult
	func setVerticalAccuracy(verticalAccuracy: Double?) -> Location {
		if let verticalAccuracy {
			self.verticalAccuracy = Int16(verticalAccuracy)
		}
		return self
	}

	@discardableResult
	func setLatitude(latitude: Double?) -> Location {
		if let latitude {
			self.latitude = latitude
		}
		return self
	}
	
	@discardableResult
	func setLongitude(longitude: Double?) -> Location {
		if let longitude {
			self.longitude = longitude
		}
		return self
	}
	
	@discardableResult
	func setTimestamp(timestamp: Date?) -> Location {
		if let timestamp {
			self.timestamp = timestamp
		}
		return self
	}

}
