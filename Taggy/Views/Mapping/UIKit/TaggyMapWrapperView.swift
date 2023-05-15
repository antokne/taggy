//
//  MapWrapperView.swift
//  Taggy
//
//  Created by Antony Gardiner on 15/05/23.
//

import Foundation
import SwiftUI
import MapKit

struct TaggyMapWrapperView: NSViewRepresentable {
	
	var viewModel: AGMapViewModel

	typealias NSViewType = TaggyMapView

	func makeNSView(context: Context) -> TaggyMapView {
		TaggyMapView()
	}
	
	func updateNSView(_ taggyMapView: TaggyMapView, context: Context) {
		taggyMapView.configure(with: viewModel)
	}
	
	
	
}
