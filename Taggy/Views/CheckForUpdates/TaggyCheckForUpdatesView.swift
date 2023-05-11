//
//  TaggyCheckForUpdatesView.swift
//  Taggy
//
//  Created by Antony Gardiner on 12/05/23.
//

import SwiftUI
import Sparkle

struct TaggyCheckForUpdatesView: View {
	@ObservedObject private var checkForUpdatesViewModel: TaggyCheckForUpdatesViewModel
	private let updater: SPUUpdater
	
	init(updater: SPUUpdater) {
		self.updater = updater
		
		// Create our view model for our CheckForUpdatesView
		self.checkForUpdatesViewModel = TaggyCheckForUpdatesViewModel(updater: updater)
	}
	
	var body: some View {
		Button("Check for Updates…", action: updater.checkForUpdates)
			.disabled(!checkForUpdatesViewModel.canCheckForUpdates)
	}
}

//struct TaggyCheckForUpdatesView_Previews: PreviewProvider {
//	static var previews: some View {
//		TaggyCheckForUpdatesView(updater: <#T##SPUUpdater#>)
//	}
//}
