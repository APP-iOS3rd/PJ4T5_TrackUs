//
//  MapViewRepresentable.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/08.
//

import SwiftUI
import MapboxMaps

// MARK: - 라이브트래킹
struct TrackingModeMapView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        return Coordinator()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: UIViewController, GestureManagerDelegate {
        private var mapView: MapView!
        private let locationManager = LocationManager.shared
        private let trackingViewModel = TrackingViewModel()
        private var locationTrackingCancellation: AnyCancelable?
        private var cancellation = Set<AnyCancelable>()
        private let countLabel = UILabel()
        private let overlayView = UIView()
        private let pauseButton = UIButton(type: .system)
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            setupCamera()
            setupUI()
            bind()
        }
        
        // 맵뷰 설정 & 초기 카메라 셋팅
        private func setupCamera() {
            guard let location = locationManager.currentLocation?.coordinate else { return }
            let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoom: 16)
            let options = MapInitOptions(cameraOptions: cameraOptions)
            self.mapView = MapView(frame: view.bounds, mapInitOptions: options)
            self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(mapView)
            
            self.mapView.location.options.puckType = .puck2D()
            self.mapView.location.options.puckBearingEnabled = true
            self.mapView.gestures.delegate = self
            self.mapView.mapboxMap.styleURI = .init(rawValue: "mapbox://styles/seokki/clslt5i0700m901r64bli645z")
        }
        
        private func setupUI() {
            self.countLabel.translatesAutoresizingMaskIntoConstraints = false
            self.overlayView.translatesAutoresizingMaskIntoConstraints = false
            self.pauseButton.translatesAutoresizingMaskIntoConstraints = false
            
            
            self.pauseButton.setTitle("일시정지", for: .normal)
            self.pauseButton.backgroundColor = UIColor.systemBackground
            self.pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
            
            self.overlayView.frame = self.view.bounds
            self.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.view.addSubview(countLabel)
            self.view.addSubview(overlayView)
            self.view.addSubview(pauseButton)
            
            NSLayoutConstraint.activate([
                self.countLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
                self.countLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
                self.pauseButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
                self.pauseButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            ])
        }
        
        // 뷰에 갱신될 값들을 바인딩
        private func bind() {
            self.trackingViewModel.$count.sink { [weak self] count in
                guard let self = self else { return }
                self.countLabel.text = "\(count)"
                if count == 0 { 
                    self.countLabel.removeFromSuperview()
                    self.overlayView.isHidden = true
                    self.startTracking()
                }
            }.store(in: &cancellation)
            
            self.trackingViewModel.$isPause.sink { [weak self] isPause in
                guard let self = self else { return }
                isPause ? self.updateOnPause() : self.updateOnPlay()
            }.store(in: &cancellation)
        }
        
        // 일시중지 됬을때
        private func updateOnPause() {
            self.overlayView.isHidden = false
            self.pauseButton.isHidden = true
            self.stopTracking()
        }
        
        // 기록중일떄
        private func updateOnPlay() {
            self.startTracking()
            self.pauseButton.isHidden = false
        }
        
        // 트래킹 시작
        private func startTracking() {
            locationTrackingCancellation =  mapView.location.onLocationChange.observe { [weak mapView] newLocation in
                guard let location = newLocation.last, let mapView else { return }
                print(location)
                mapView.camera.ease(
                    to: CameraOptions(center: location.coordinate, zoom: 15),
                    duration: 1.3)
            }
        }
        
        // 트래킹 종료
        private func stopTracking() {
            locationTrackingCancellation?.cancel()
        }
        
        @objc func pauseButtonTapped() {
            self.trackingViewModel.isPause = true
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
            
        }
    }
}

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
        private var locationTrackingCancellation: AnyCancelable?
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
            mapView.mapboxMap.styleURI = StyleURI(rawValue: "mapbox://styles/seokki/clslt5i0700m901r64bli645z")
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
            locationButton.addTarget(self, action: #selector(centerMapOnUser), for: .touchDown)
            
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
        @objc private func centerMapOnUser() {
            guard let userLocation = locationManager.currentLocation?.coordinate else {
                // 사용자의 위치를 가져올 수 없는 경우 예외 처리
                print("사용자의 위치를 가져올 수 없습니다.")
                return
            }
            let camera = CameraOptions(center: userLocation, zoom: 14, bearing: 0, pitch: 0)
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
            let cameraOptions = CameraOptions(center: centerPostion, zoom: 16)
            let myMapInitOptions = MapInitOptions(cameraOptions: cameraOptions)
            
            self.mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
            self.mapView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            self.mapView.ornaments.options.scaleBar.visibility = .visible
            self.mapView.mapboxMap.styleURI = StyleURI(rawValue: "mapbox://styles/seokki/clslt5i0700m901r64bli645z")
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
