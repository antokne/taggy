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
	
	class func sortedFetchRequest(tag: Tag? = nil, ascending: Bool = true) -> NSFetchRequest<Location> {
		let fetchRequest = NSFetchRequest<Location>(entityName: Location.className)
		var subPredicates: [NSPredicate] = []
		if let tag {
			subPredicates.append(\Location.tag == tag)
		}
		
		fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: subPredicates)
		let sortDescriptor = NSSortDescriptor(keyPath: \Location.timestamp, ascending: ascending)
		fetchRequest.sortDescriptors = [sortDescriptor]
		return fetchRequest
	}
	
	
	/// For the location for a timestamp or newest if nil
	/// - Parameters:
	///   - tag: tag to find location for
	///   - timestamp: the location for timestamp to find or nil
	///   - context: core data context to use
	/// - Returns: a location
	class func findLocation(tag: Tag, timestamp: Date? = nil, context: NSManagedObjectContext) -> Location? {
		
		let fetchRequest = NSFetchRequest<Location>(entityName: Location.className)
		
		var subPredicates: [NSPredicate] = []

		subPredicates.append(\Location.tag == tag)
		if let timestamp {
			subPredicates.append(\Location.timestamp == timestamp)
		}
		fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: subPredicates)
		let sortDescriptor = NSSortDescriptor(keyPath: \Location.timestamp, ascending: false)
		fetchRequest.sortDescriptors = [sortDescriptor]
		do {
			let result = try context.fetch(fetchRequest)
			return result.first
		}
		catch {
			return nil
		}
	}
	
	/// Calculate the rate in count/seconds
	/// - Parameters:
	///   - tag: the tag to calcualte for
	///   - context: core data context
	/// - Returns: the rate in number/second
	class func calculatePingRate(tag: Tag, context: NSManagedObjectContext) -> Double {
		
		let fetchRequest = sortedFetchRequest(tag: tag)
		fetchRequest.fetchLimit = 100
		
		do {
			let results = try context.fetch(fetchRequest)
			guard let first = results.first?.timestamp?.timeIntervalSince1970,
					let last = results.last?.timestamp?.timeIntervalSince1970 else {
				return 0
			}
			let count = results.count
			let diffS = last - first
			let rate = Double(count) / diffS
			
			return rate
			
		}
		catch {
			return 0
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
