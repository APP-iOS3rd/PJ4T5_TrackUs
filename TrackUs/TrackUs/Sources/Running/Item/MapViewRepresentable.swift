//
//  MapViewRepresentable.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/08.
//

import SwiftUI
import MapboxMaps

// MARK: - 현재위치를 나타내는 맵뷰
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
            guard let currentLocation = locationManager.currentLocation?.coordinate else {
                print("DEBUG: 유저 위치를 가져오기 실패")
                return
            }
            let camera = CameraOptions(center: currentLocation, zoom: 14, bearing: 0, pitch: 0)
            mapView.camera.ease(to: camera, duration: 1.3)
        }
    }
}

// MARK: - 경로를 보여주는 맵뷰
struct RouteMapView: UIViewControllerRepresentable {
    let lineCoordinates: [CLLocationCoordinate2D]
    
    func makeUIViewController(context: Context) -> UIViewController {
        return Coordinator(lineCoordinates: lineCoordinates)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(lineCoordinates: lineCoordinates)
    }
    
    class Coordinator: UIViewController, GestureManagerDelegate {
        private var mapView: MapView!
        private let lineCoordinates: [CLLocationCoordinate2D]
        
        init(lineCoordinates: [CLLocationCoordinate2D]) {
            self.lineCoordinates = lineCoordinates
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            var centerPostion = lineCoordinates.first!
            if let updatedCenterPosition = self.calculateCenterCoordinate(for: lineCoordinates) {
                centerPostion = updatedCenterPosition
            }
            
            // TODO: - 줌레벨을 거리에 따라서 설정하도록 구현하기
            let cameraOptions = CameraOptions(center: centerPostion, zoom: 12)
            let myMapInitOptions = MapInitOptions(cameraOptions: cameraOptions)
            self.mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
            self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.mapView.ornaments.options.scaleBar.visibility = .visible
            self.mapView.mapboxMap.styleURI = .init(rawValue: "mapbox://styles/seokki/clslt5i0700m901r64bli645z")
            view.addSubview(mapView)
            
            drawRoute()
        }
        
        func drawRoute() {
            var lineAnnotation = PolylineAnnotation(lineCoordinates: lineCoordinates)
            lineAnnotation.lineColor = StyleColor(UIColor.main)
            lineAnnotation.lineWidth = 5
            lineAnnotation.lineJoin = .round
            let lineAnnotationManager = mapView.annotations.makePolylineAnnotationManager()
            lineAnnotationManager.annotations = [lineAnnotation]
            
            let startCoordinate = self.lineCoordinates.first!
            let endCoordinate = self.lineCoordinates.last!
            var startPointAnnotation = PointAnnotation(coordinate: startCoordinate)
            var endPointAnnotation = PointAnnotation(coordinate: endCoordinate)
            startPointAnnotation.image = .init(image: UIImage(named: "StartPin")!, name: "start-pin")
            endPointAnnotation.image = .init(image: UIImage(named: "Puck")!, name: "end-pin")
            let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
            if startCoordinate == endCoordinate {
                pointAnnotationManager.annotations = [startPointAnnotation]
            } else {
                pointAnnotationManager.annotations = [startPointAnnotation, endPointAnnotation]
            }
        }
        
        func calculateCenterCoordinate(for coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
            guard !coordinates.isEmpty else {
                return nil
            }
            
            // 위도와 경도의 평균값 계산
            let totalLatitude = coordinates.map { $0.latitude }.reduce(0, +)
            let totalLongitude = coordinates.map { $0.longitude }.reduce(0, +)
            
            let averageLatitude = totalLatitude / Double(coordinates.count)
            let averageLongitude = totalLongitude / Double(coordinates.count)
            return CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
            
        }
    }
}
