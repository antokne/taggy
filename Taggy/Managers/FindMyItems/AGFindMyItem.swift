//
//  AGFindMyItem.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import Cocoa

public class AGFindMyItem {

	private let data: Dictionary<String, Any>
	
	init(json: Dictionary<String, Any>) {
		self.data = json
	}
	
}


extension AGFindMyItem {
	
	var role: Dictionary<String, Any>? {
		data["role"] as? Dictionary<String, Any>
	}

	var emojo: String? {
		role?["emoji"] as? String
	}
	
	var roleName: String? {
		role?["name"] as? String
	}

	var serialNumber: String? {
		data["serialNumber"] as? String
	}
	
	var identifier: UUID? {
		UUID(uuidString: data["identifier"] as? String ?? "")
	}
	
	var location: Dictionary<String, Any>? {
		data["location"] as? Dictionary<String, Any>
	}
	
	/// altitude
	var altitude: Int? {
		if let string = location?["altitude"] as? String {
			return Int(string)
		}
		return nil
	}
	
	// floor
	var floor: Int? {
		if let string = location?["floor"] as? String {
			return Int(string)
		}
		return nil
	}
	// horizontalAccuracy
	var horizontalAccuracy: Double? {
		if let value = location?["horizontalAccuracy"] as? Double {
			return value
		}
		return nil
	}
	
	// isOld
	var isOld: Bool {
		if let intValue = location?["isOld"] as? Int {
			return intValue == 1 ? true : false
		}
		return false
	}
	
	// latitude
	var latitude: Double? {
		if let value = location?["latitude"] as? Double {
			return value
		}
		return nil
	}
	
	// longitude
	var longitude: Double? {
		if let value = location?["longitude"] as? Double {
			return value
		}
		return nil
	}
	
	// timestamp
	var timestamp: Date? {
		if let intValue = location?["timeStamp"] as? Int {
			return Date(timeIntervalSince1970: Double(intValue) / 1000.0)
		}
		return nil
	}

	// verticalAccuracy
	var verticalAccuracy: Double? {
		if let value = location?["verticalAccuracy"] as? Double {
			return value
		}
		return nil
	}
	
	// batteryStatus
	// name
	var name: String? {
		data["name"] as? String
	}
	
}
