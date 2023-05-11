//
//  TaggyCheckForUpdatesViewModel.swift
//  Taggy
//
//  Created by Antony Gardiner on 12/05/23.
//

import SwiftUI
import Sparkle

final class TaggyCheckForUpdatesViewModel: ObservableObject {
	@Published var canCheckForUpdates = false
	
	init(updater: SPUUpdater) {
		updater.publisher(for: \.canCheckForUpdates)
			.assign(to: &$canCheckForUpdates)
	}
}
