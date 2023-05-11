//
//  TaggyGeneralSettingsView.swift
//  Taggy
//
//  Created by Antony Gardiner on 11/05/23.
//

import SwiftUI



struct TaggyGeneralSettingsView: View {
	
	@AppStorage(AGTagCollector.TagCollectingRateMinuteName) private var collectingRateMinute = 1.0

	var body: some View {
		Form {
			Slider(value: $collectingRateMinute, in: 1...60, step: 5) {
				Text("Poll rate (min):")
			} minimumValueLabel: {
				Text("1m")
			} maximumValueLabel: {
				Text("60m")
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
