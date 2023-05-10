//
//  AGTaggyManager.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import Foundation

public class AGTaggyManager {

	public lazy var persistenceController: PersistenceController = {
		PersistenceController.shared
	}()
	
	public lazy var collector: AGTagCollector = {
		AGTagCollector.shared
	}()
	
	public static var shared: AGTaggyManager = AGTaggyManager()

}
