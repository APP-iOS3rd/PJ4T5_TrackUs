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
            setupFilterButton()
            setupAddRunningButton()

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
                locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
                locationButton.widthAnchor.constraint(equalToConstant: buttonWidth),
                locationButton.heightAnchor.constraint(equalToConstant: buttonWidth)
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
        
        private func setupAddRunningButton() {
            let buttonWidth = 52.0
            let plusButton = UIButton(type: .custom)
            plusButton.setImage(UIImage(named: "Plus"), for: .normal)
            plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchDown)
            plusButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(plusButton)
            
            NSLayoutConstraint.activate([
                plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
                plusButton.widthAnchor.constraint(equalToConstant: buttonWidth),
                plusButton.heightAnchor.constraint(equalToConstant: buttonWidth)
            ])
        }
        
        @objc private func plusButtonTapped() {
            print("버튼이 눌렸습니다.")
        }
        
        private func setupFilterButton() {
            let buttonWidth: CGFloat = 71
            let buttonHeight: CGFloat = 28
            
            let filterButton = UIButton(type: .custom)
            filterButton.backgroundColor = .white
            filterButton.layer.cornerRadius = 14
            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchDown)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(filterButton)
            
            let filterImageView = UIImageView(image: UIImage(named: "Filter"))
            filterImageView.contentMode = .center
            filterImageView.translatesAutoresizingMaskIntoConstraints = false
            filterButton.addSubview(filterImageView)
            
            let filterLabel = UILabel()
            filterLabel.text = "필터"
            filterLabel.contentMode = .center
            filterLabel.font = UIFont.boldSystemFont(ofSize: 12)
            filterLabel.textColor = .gray2
            filterLabel.translatesAutoresizingMaskIntoConstraints = false
            filterButton.addSubview(filterLabel)
            
            NSLayoutConstraint.activate([
                filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
                filterButton.widthAnchor.constraint(equalToConstant: buttonWidth),
                filterButton.heightAnchor.constraint(equalToConstant: buttonHeight),
                
                filterImageView.leadingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: 12),
                filterImageView.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor),
                filterImageView.heightAnchor.constraint(equalToConstant: 16),
                filterImageView.widthAnchor.constraint(equalToConstant: 16),
                
                filterLabel.trailingAnchor.constraint(equalTo: filterButton.trailingAnchor, constant: -12),
                filterLabel.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor)
            ])
        }
        
        
        @objc private func filterButtonTapped() {
            print("Filter 버튼이 눌렸습니다.")
        }
    }
}
