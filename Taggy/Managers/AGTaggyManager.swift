//
//  AGTaggyManager.swift
//  Taggy
//
//  Created by Antony Gardiner on 9/05/23.
//

import Foundation
import Sparkle

public class AGTaggyManager {

	public lazy var persistenceController: PersistenceController = {
		PersistenceController.shared
	}()
	
	public lazy var collector: AGTagCollector = {
		AGTagCollector.shared
	}()
	
	public lazy var updateController: SPUStandardUpdaterController = {
		SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
	}()
	
	public static var shared: AGTaggyManager = AGTaggyManager()

}
