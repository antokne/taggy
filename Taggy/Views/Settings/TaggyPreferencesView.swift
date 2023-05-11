//
//  TaggyPreferencesView.swift
//  Taggy
//
//  Created by Antony Gardiner on 11/05/23.
//

import SwiftUI

struct TaggyPreferencesView: View {
	
	private enum Tabs: Hashable {
		case general
	}
	
	var body: some View {
		TabView {
			TaggyGeneralSettingsView()
				.tabItem {
					Label("General", systemImage: "gear")
				}
				.tag(Tabs.general)
		}
		.padding(20)
		.frame(width: 400, height: 150)
	}
}

struct TaggyPreferencesView_Previews: PreviewProvider {
	static var previews: some View {
		TaggyPreferencesView()
	}
}
