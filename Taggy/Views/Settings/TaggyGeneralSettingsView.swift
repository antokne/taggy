//
//  TaggyGeneralSettingsView.swift
//  Taggy
//
//  Created by Antony Gardiner on 11/05/23.
//

import SwiftUI



struct TaggyGeneralSettingsView: View {
	
	@AppStorage(AGTagCollector.TagCollectingRateMinuteName) private var collectingRateMinute = 1.0
	@AppStorage(TaggyGeneralSettingsViewModel.TagShowMenuBarExtraName) private var showMenuBarExtra = true
	@AppStorage(TaggyGeneralSettingsViewModel.TagStartRecordingOnOpenName) private var startRecordingOnOpen = false

	var body: some View {
		Form {
			Section {
				Toggle("Start recording on app start", isOn: $startRecordingOnOpen)
				Toggle("Show Taggy icon in menu bar", isOn: $showMenuBarExtra)
				Spacer()
				Slider(value: $collectingRateMinute, in: 1...60, step: 5) {
					Text("Poll rate (min):")
				} minimumValueLabel: {
					Text("1m")
				} maximumValueLabel: {
					Text("60m")
				}
				Spacer()
			}
		}
		.padding(20)
		.frame(width: 400, height: 100)
	}
}

struct TaggyGeneralSettingsView_Previews: PreviewProvider {
	static var previews: some View {
		TaggyGeneralSettingsView()
	}
}
