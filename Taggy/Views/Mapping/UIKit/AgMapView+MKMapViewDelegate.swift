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
			lineView.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
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
//			anoView.glyphTintColor = .blue
			anoView.image = NSImage(systemSymbolName: "circle", variableValue: 6564664, accessibilityDescription: "circle")?
				.withSymbolConfiguration(configuration)
			
			//anoView.centerOffset = CGPoint(x: 0, y: -(anoView.image?.size.height ?? 0) / 2.0)
		}
		return anoView
	}
	
}
