//
//  AgMapView+MKMapViewDelegate.swift
//  Taggy
//
//  Created by Antony Gardiner on 15/05/23.
//

import Foundation
import MapKit

extension AGMapViewModel: MKMapViewDelegate {
	
	public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		
		if overlay is MKPolyline {
			let lineView = MKPolylineRenderer(overlay: overlay)
			lineView.strokeColor = NSColor.controlAccentColor
			lineView.lineWidth = 2
			return lineView
		}
		
		return MKOverlayRenderer()
	}
	
	public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		let reuseId = "annotationView"
		var anoView: MKAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
		if anoView == nil {
			anoView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
		}
		
		if let anoView {
			if let annotation = annotation as? TaggyAnnotation {
				anoView.toolTip = annotation.emoji
			}
			
			let lastAnnotation = annotation.coordinate == locations.first?.coordinate

			anoView.image = NSImage(systemSymbolName: "airtag.fill", variableValue: 6564664, accessibilityDescription: "tag")?
				.withSymbolConfiguration(symbolConfiguration(for: lastAnnotation))
			
			anoView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
			
			//anoView.centerOffset = CGPoint(x: 0, y: -(anoView.image?.size.height ?? 0) / 2.0)
		}
		return anoView
	}
	
}
