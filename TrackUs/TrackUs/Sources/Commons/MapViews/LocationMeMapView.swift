//
//  LocationMeMapView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI
import MapboxMaps

/**
 현재 위치를 나타내는 맵뷰(기본)
 */
struct LocationMeMapView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return Coordinator()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: UIViewController, GestureManagerDelegate {
        internal var mapView: MapView!
        private let locationManager = LocationManager.shared
        private lazy var locationButton = UIButton(frame: .zero)
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            let bounds = CoordinateBounds(
                southwest: CLLocationCoordinate2D(latitude: 33.0, longitude: 124.0),
                northeast: CLLocationCoordinate2D(latitude: 38.0, longitude: 132.0))
            
            let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: locationManager.currentLocation?.coordinate.latitude ?? 37.57098684878895, longitude: locationManager.currentLocation?.coordinate.longitude ?? 126.97891142355786), zoom: 14, bearing: 0, pitch: 0)
            let cameraBoundsOptions = CameraBoundsOptions(bounds: bounds)
            let myMapInitOptions = MapInitOptions(cameraOptions: cameraOptions)
            
            mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapView.mapboxMap.styleURI = .init(rawValue: "mapbox://styles/seokki/clslt5i0700m901r64bli645z")
            try? mapView.mapboxMap.setCameraBounds(with: cameraBoundsOptions)
            self.view.addSubview(mapView)
            
            setupLocationButton()
            
            mapView.location.options.puckType = .puck2D()
            mapView.gestures.delegate = self // gesture delegate
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
            
        }
        
        public override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        }
        
        private func setupLocationButton() {
            locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchDown)
            
            if #available(iOS 13.0, *) {
                locationButton.setImage(UIImage(named: "locationButton"), for: .normal)
            } else {
                locationButton.setTitle("No tracking", for: .normal)
            }
            
            let buttonWidth = 44.0
            locationButton.translatesAutoresizingMaskIntoConstraints = false
            locationButton.layer.cornerRadius = buttonWidth/2
            locationButton.layer.shadowOffset = CGSize(width: -1, height: 1)
            locationButton.layer.shadowColor = UIColor.black.cgColor
            locationButton.layer.shadowOpacity = 0.5
            view.addSubview(locationButton)
            
            NSLayoutConstraint.activate([
                locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                locationButton.widthAnchor.constraint(equalTo: locationButton.heightAnchor),
                locationButton.widthAnchor.constraint(equalToConstant: buttonWidth)
            ])
        }
        
        @objc private func locationButtonTapped() {
            locationManager.getCurrentLocation()
            guard let currentLocation = locationManager.currentLocation?.coordinate else {
                print("DEBUG: 유저 위치를 가져오기 실패")
                return
            }
            let camera = CameraOptions(center: currentLocation, zoom: 14, bearing: 0, pitch: 0)
            mapView.camera.ease(to: camera, duration: 1.3)
        }
    }
}
