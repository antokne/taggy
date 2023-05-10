//
//  AGLocationViewModel.swift
//  Taggy
//
//  Created by Antony Gardiner on 10/05/23.
//

import Foundation
import SwiftUI
import AGCore

extension Location {
	
	var formatter: AGFormatter {
		AGFormatter.sharedFormatter
	}
	
	var dateString: String {
		formatter.formatDate(date: timestamp ?? Date())
	}

	var timeString: String {
		formatter.formatTime(date: timestamp ?? Date())
	}
	
	var longitudeString: String {
		String(format: "%3.4f", longitude)
	}
	
	var latitudeString: String {
		String(format: "%3.4f", latitude)
	}
	
	var tagName: String {
		tag?.name ?? "?"
	}
}
