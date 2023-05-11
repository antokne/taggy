//
//  AGCommonViews.swift
//  Taggy
//
//  Created by Antony Gardiner on 11/05/23.
//

import Foundation
import SwiftUI

let FailedToStartAlertView = Alert(title: Text("Failed to start monitoring Find My Data"),
								   message: Text("Please check in System Settings -> Privacy & Security -> Full Disk Access that Taggy access is enabled. \nThen try again."),
								   dismissButton: .default(Text("OK")))
