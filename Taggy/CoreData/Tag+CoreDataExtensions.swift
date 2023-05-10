//
//  Tag+CoreDataExtensions.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import Foundation
import CoreData
import AGCore

extension Tag {
	
	class func findActiveComponent(uuid: UUID, context: NSManagedObjectContext) -> Tag? {
		
		let fetchRequest = NSFetchRequest<Tag>(entityName: Tag.className)
		fetchRequest.predicate = \Tag.uuid == uuid
		
		do {
			let result = try context.fetch(fetchRequest)
			return result.first
		}
		catch {
			return nil
		}
	}
	
	@discardableResult
	class func add(context: NSManagedObjectContext) -> Tag {
		let newTag = Tag(context: context)
		newTag.createdAt = Date()
		newTag.updatedAt = Date()
		return newTag
	}

	@discardableResult
	func setName(name: String?) -> Tag {
		if let name {
			self.name = name
			self.updatedAt = Date()
		}
		return self
	}

	@discardableResult
	func setEmoji(emoji: String?) -> Tag {
		if let emoji {
			self.emoji = emoji
			self.updatedAt = Date()
		}
		return self
	}

	@discardableResult
	func setUuid(uuid: UUID?) -> Tag {
		if let uuid {
			self.uuid = uuid
			self.updatedAt = Date()
		}
		return self
	}
}
