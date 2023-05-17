//
//  TaggyMapView.swift
//  Taggy
//
//  Created by Antony Gardiner on 15/05/23.
//

import Cocoa
import MapKit
import AGCore

protocol TaggyMapAppDelegateProtcol {
	func resetZoom()
	func getStatus() -> String
	func showLine(show: Bool)
}

public class TaggyMapView: NSView {

	private var viewModel: AGMapViewModel?
	private var coordinateRegion: MKCoordinateRegion?

	private var containerView: NSView?

	private var mapView: MKMapView?
	private var statusView: StatusView?

	public func configure(with viewModel: AGMapViewModel?) {
		self.viewModel = viewModel
		createViews()
		configureMapView()
		setVisibleMap()
	}
	
	func createViews() {
		
		if containerView == nil {
			self.containerView = NSView()
		}
		
		if statusView == nil {
			self.statusView = StatusView()
		}
		
		self.statusView?.delegate = self
		
		if mapView == nil {
			self.mapView = MKMapView()
		}
		
		addViews()
	}
	
	func configureMapView() {
		guard let mapView,
			  let viewModel else {
			return
		}
		
		mapView.delegate = viewModel
		
		mapView.removeAnnotations(mapView.annotations)
		mapView.removeOverlays(mapView.overlays)
		
		mapView.showsZoomControls = true
		mapView.showsScale = true
		mapView.showsCompass = true
		
		if viewModel.showLineOnMap {
			mapView.addOverlay(viewModel.polyline)
		}
		
		mapView.addAnnotations(viewModel.annotations)
	}
	
	func setVisibleMap() {
		
		guard let mapView,
			  let viewModel else {
			return
		}
		
		mapView.setVisibleMapRect(viewModel.boundingRect,
								  edgePadding: NSEdgeInsets(top: 50, left: 20, bottom: 20, right: 20),
								  animated: true)
	}

	func addViews() {
		
		guard let mapView,
			  let containerView,
			  let statusView else {
			return
		}
		
		statusView.configureView(showLineOnMap: viewModel?.showLineOnMap ?? false)
		
		self.addSubview(containerView)
		containerView.createConstraints
			.left()
			.top()
			.right()
			.bottom()
		
		containerView.addSubview(mapView)
		containerView.addSubview(statusView)
		
		mapView.createConstraints
			.left()
			.right()
			.top()
			.bottomTo(anchor: statusView.topAnchor)

		statusView.createConstraints
			.left()
			.right()
			.bottom()
			.height(33)
		
	}
}

extension TaggyMapView: TaggyMapAppDelegateProtcol {
	
	func showLine(show: Bool) {
		self.viewModel?.showLineOnMap = show
		configureMapView()
	}
	
	func getStatus() -> String {
		"\(viewModel?.locations.count ?? 0) locations"
	}
	
	func resetZoom() {
		setVisibleMap()
	}
	
}

class StatusView: NSView {
	
	var resetButton: NSButton?
	var checkboxDrawLinesButton: NSButton?
	var label: NSLabel?
	
	var delegate: TaggyMapAppDelegateProtcol?
	
	func configureView(showLineOnMap: Bool) {
			
		createViews()
		
		guard // let resetButton,
			  let label else {
			return
		}

		label.stringValue = delegate?.getStatus() ?? ""

		if showLineOnMap {
			checkboxDrawLinesButton?.state = .on
		}
		
	}
	
	func createViews() {
		
		if checkboxDrawLinesButton == nil {
			checkboxDrawLinesButton = NSButton(title: "Show Tracking Line", target: self, action: #selector(showLine))
			checkboxDrawLinesButton?.setButtonType(.switch)
			checkboxDrawLinesButton?.state = .off
			
			guard let checkboxDrawLinesButton else {
				return
			}
			
			self.addSubview(checkboxDrawLinesButton)
			checkboxDrawLinesButton.createConstraints
				.top()
				.left(80)
				.bottom()
		}
		
		if resetButton == nil {
			resetButton = NSButton(title: "Reset", target: self, action: #selector(reset))
			
			guard let resetButton else {
				return
			}
			
			self.addSubview(resetButton)
			resetButton.createConstraints
				.left(5)
				.top()
				.bottom()
				
		}
		
		if label == nil {
			label = NSLabel()
			label?.alignment = .left
//			label?.isBordered = true
			
			guard let label, let checkboxDrawLinesButton else {
				return
			}
			
			self.addSubview(label)
			label.createConstraints
				.top(10)
				.right(-10)
				.bottom()
				.leftTo(anchor: checkboxDrawLinesButton.rightAnchor)
		}

		
	}
	
	@objc func reset(button: NSButton) {
		delegate?.resetZoom()
	}
	
	@objc func showLine(button: NSButton) {
		delegate?.showLine(show: button.state == .on ? true : false)
	}
}
