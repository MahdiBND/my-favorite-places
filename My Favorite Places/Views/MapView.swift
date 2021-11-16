// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  MapView.swift
//  GoogleMapsSwiftUI
//
//  Created by Chris Arriola on 2/5/21.
//

import GoogleMaps
import SwiftUI

// MARK: - MapView

/// The wrapper for `GMSMapView` so it can be used in SwiftUI
struct MapView: UIViewControllerRepresentable {
	
	@Binding var markers: [GMSMarker]
	@Binding var selectedMarker: GMSMarker?
	@Binding var position: GMSCameraPosition?

	var onAnimationEnded: (() -> Void)? = nil
	var mapViewWillMove: ((Bool) -> Void)? = nil
	
	func makeUIViewController(context: Context) -> MapViewController {
		let uiViewController = MapViewController()
		uiViewController.map.delegate = context.coordinator
		return uiViewController
	}
	
	func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
		uiViewController.map.clear()
		markers.forEach { marker in
			marker.map = uiViewController.map
		}
		selectedMarker?.map = uiViewController.map
		animateToSelectedMarker(viewController: uiViewController)
	}
	
	func makeCoordinator() -> MapViewCoordinator {
		return MapViewCoordinator(self)
	}
	
	private func animateToSelectedMarker(viewController: MapViewController) {
		guard let selectedMarker = selectedMarker else {
			return
		}
		
		let map = viewController.map
		if map.selectedMarker != selectedMarker {
			map.selectedMarker = selectedMarker
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				map.animate(toZoom: kGMSMinZoomLevel)
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					map.animate(with: GMSCameraUpdate.setTarget(selectedMarker.position))
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						map.animate(toZoom: 15)
						
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
							if let action = onAnimationEnded {
								action()
							}
						}
					}
				}
			}
		}
	}
	
	final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
		var mapView: MapView
		
		init(_ mapView: MapView) {
			self.mapView = mapView
		}
		
		func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
			if let moveAction = self.mapView.mapViewWillMove {
				moveAction(gesture)
			}
		}
		
		func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
			self.mapView.position = position
			if let animateAction = self.mapView.onAnimationEnded {
				animateAction()
			}
		}

	}
}

// MARK: - MapViewController

class MapViewController: UIViewController {
	
	let map =  GMSMapView(frame: .zero)
	var isAnimating: Bool = false
	
	override func loadView() {
		super.loadView()
		self.view = map
	}
}
