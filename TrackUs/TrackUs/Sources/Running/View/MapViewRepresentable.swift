//
//  MapViewRepresentable.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/08.
//

import SwiftUI
import MapboxMaps

struct MapViewRepresentable: UIViewControllerRepresentable {
    @ObservedObject var mapViewModel: MapViewModel
    
    // UIKit 인스턴스를 반환
    func makeUIViewController(context: Context) -> UIViewController {
        let coordinator = Coordinator(mapViewModel: mapViewModel)
        return coordinator
    }
    
    // View가 업데이트될떄
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapViewModel: mapViewModel)
    }
    
    class Coordinator: UIViewController, GestureManagerDelegate {
        let mapViewModel: MapViewModel
        let locationManager = LocationManager.shared
        internal var mapView: MapView!
        private var locationTrackingCancellation: AnyCancelable?
        
        init(mapViewModel: MapViewModel) {
            self.mapViewModel = mapViewModel
            self.mapView = mapViewModel.mapView
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            mapViewModel.setupMapView(frame: view.bounds)
            self.view.addSubview(mapViewModel.mapView)
            mapViewModel.mapView.gestures.delegate = self // gesture delegate
            mapViewModel.startTracking()
        }
        
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
            
        }
    }
}

