//
//  AGCollectorFindMyItems.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import Foundation
import Combine
import SFSMonitor
import CoreData
import OSLog

public class AGTagCollectorFindMyItems: AGTagCollectorProtocol {
	
	private var FindMyAirTagsFile = "\(FileManager.default.homeDirectoryForCurrentUser)Library/Caches/com.apple.findmy.fmipcore/Items.data"

	private let monitorDispatchQueue =  DispatchQueue(label: "AGTagCollectorFindMyItemsDispatchQueue", qos: .utility)
	
	private var monitor: SFSMonitor?

	let log = Logger(subsystem: Bundle.mainBundleId ?? "Taggy", category: "AGTagCollectorFindMyItems")
	
	func startCollectingImpl() {
		monitor = SFSMonitor(delegate: self)
		monitor?.setMaxMonitored(number: 10)
		
		if let url = URL(string: FindMyAirTagsFile) {
			
			let result = monitor?.addURL(url)
			switch result {
			case 0:
				// ok
				log.debug("Starting monitoring item file \(url)")
			case 1:
				log.debug("File \(url) is already being monitored")
			case 2:
				log.debug("Failed to start monitoring file \(url), too many files being monitored.")
			default:
				log.debug("Failed to start monitoring file \(url).")
			}
			
			handleTagData(url: url)
		}
		
	}
	
	func stopCollectingImpl() {
		
		log.debug("Stop montoring item file")
		
		if let url = URL(string: FindMyAirTagsFile) {
			monitor?.removeURL(url)
		}
	}
	
	func handleTagData(url: URL) {
		log.info("Notified of change of item file \(url)")
		loadFileData(url: url)
	}

	func loadFileData(url: URL) {
		if let json = readFile(url: url) {
			for jsonItem in json {
				let item = AGFindMyItem(json: jsonItem)
				addRecord(item: item)
			}
		}
	}
	
	func readFile(url: URL) -> Array<Dictionary<String,Any>>? {
		
		do {
			let data = try Data(contentsOf: url)
			if let json = try JSONSerialization.jsonObject(with: data) as? Array<Dictionary<String,Any>> {
				return json
			}
		}
		catch {
			log.warning("Failed to load contents of \(url) error: \(error)")
		}
		return nil
	}
	
	func addRecord(item: AGFindMyItem) {
		AGTaggyManager.shared.persistenceController.performInBackground { context in
			
			guard let uuid = item.identifier else {
				self.log.warning("item \(item.name ?? "") has no identfier set, skipping")
				return
			}
			
			var existingTag = Tag.findActiveComponent(uuid: uuid, context: context)
			if let existingTag {
				updateTagRecord(existingItem: existingTag, item: item)
				self.log.info("Updated existing tag with name \(existingTag.name ?? "?")")
			}
			else {
				existingTag = addTagRecord(item: item, context: context)
				self.log.info("Added new tag with name \(existingTag?.name ?? "?")")
			}
			
			guard let existingTag else {
				self.log.error("Failed to add or update item \(item.name ?? "").")
				return
			}
			
			guard let timestamp = item.timestamp else {
				self.log.warning("item \(item.name ?? "") has no timestamp set, skipping")
				return
			}
			
			var location: Location? = Location.findLocation(tag: existingTag, timestamp: timestamp, context: context)
			if location == nil {
				location = addLocationRecord(item: item, context: context)
				location?.tag = existingTag
				self.log.info("Add location with timestamp \(timestamp) \(location?.latitude ?? -1):\(location?.longitude ?? -1) to tag with name \(existingTag.name ?? "?")")
			}
			else {
				self.log.info("Location with timestamp \(timestamp) already added for tag with name \(existingTag.name ?? "?")")
			}
			
			try? context.save()
		}
		
		func addTagRecord(item: AGFindMyItem, context: NSManagedObjectContext) -> Tag {
			return  Tag.add(context: context)
				.setName(name: item.name)
				.setEmoji(emoji: item.emojo)
				.setUuid(uuid: item.identifier)
		}
		
		func updateTagRecord(existingItem:Tag, item: AGFindMyItem) {
			if existingItem.emoji != item.emojo {
				existingItem.setEmoji(emoji: item.emojo)
			}
			if existingItem.name != item.name {
				existingItem.setName(name: item.name)
			}
		}
		
		func addLocationRecord(item: AGFindMyItem, context: NSManagedObjectContext) -> Location {
			
			return Location.add(context: context)
				.setAltitude(altitude: item.altitude)
				.setFloor(floor: item.floor)
				.setHorizontalAccuracy(horizontalAccuracy: item.horizontalAccuracy)
				.setVerticalAccuracy(verticalAccuracy: item.verticalAccuracy)
				.setLatitude(latitude: item.latitude)
				.setLongitude(longitude: item.longitude)
				.setTimestamp(timestamp: item.timestamp)
		}
	}
	
}

extension AGTagCollectorFindMyItems: SFSMonitorDelegate {
	
	public func receivedNotification(_ notification: SFSMonitorNotification, url: URL, queue: SFSMonitor) {
		print("\(notification.toStrings().map { $0.rawValue }) @ \(url.path)")
		
		handleTagData(url: url)

	}
	
}
