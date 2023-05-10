//
//  AGTagCollector.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import Foundation

/// Protocol to use to create new collectors.
protocol AGTagCollectorProtocol {
	func startCollectingImpl()
	func stopCollectingImpl()
}

public class AGTagCollector {

	public static let shared: AGTagCollector = AGTagCollector()
	
	public var isCollecting: Bool = false

	let collectors:[AGTagCollectorProtocol] = [AGTagCollectorFindMyItems()]

	func startCollecting() {
		isCollecting = true
		for collector in collectors {
			collector.startCollectingImpl()
		}
	}
	
	func stopCollecting() {
		isCollecting = false
		for collector in collectors {
			collector.stopCollectingImpl()
		}
	}
}
