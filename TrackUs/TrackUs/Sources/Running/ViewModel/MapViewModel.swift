//
//  MapViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/08.
//

import SwiftUI
import MapboxMaps
import Combine


class MapViewModel: ObservableObject {
    private let locationManager = LocationManager.shared
    private let authViewModel = AuthenticationViewModel.shared
    private var locationTrackingCancellation: AnyCancelable?
    var lineCoordinates: [CLLocationCoordinate2D] = []
    private var lineAnnotation: PolylineAnnotation!
    private var lineAnnotationManager: PolylineAnnotationManager!
    private var puckConfiguration = Puck2DConfiguration.makeDefault(showBearing: true)
    @Published var mapView: MapView!
    @Published var timer = Timer.publish(every: 1, on: .main, in: .default)
    @Published var timerHandler: Cancellable?
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var calorie = 0.0
    @Published var elapsedTime = 0.0
    
    // 맵뷰 초기설정
    func setupMapView(frame: CGRect) {
        // 초기설정
        guard let coordinate = locationManager.currentLocation?.coordinate else { return }
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), zoom: 17)
        let myMapInitOptions = MapInitOptions(cameraOptions: cameraOptions)
        self.mapView = MapView(frame: frame, mapInitOptions: myMapInitOptions)
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapView.mapboxMap.styleURI = .light
        self.puckConfiguration.topImage = UIImage(named: "Puck")
        self.mapView.location.options.puckType = .puck2D(puckConfiguration)
        self.mapView.location.options.puckBearingEnabled = true
        
        // 경로설정
        self.lineAnnotation = PolylineAnnotation(lineCoordinates: self.lineCoordinates)
        self.lineAnnotationManager = self.mapView.annotations.makePolylineAnnotationManager()
        self.lineAnnotationManager.annotations = [self.lineAnnotation]
        
        lineCoordinates.append(coordinate)
    }
    
    // 기록시작
    func startTracking() {
        // 타이머 활성화
        timer = Timer.publish(every: 1, on: .main, in: .default)
        timerHandler = timer.connect()
        
        // TODO: - 이동거리 범위가 적은 경우 경로에 추가하지 않기
        self.locationTrackingCancellation = mapView.location.onLocationChange.observe({ [weak mapView] newLocation in
            let dataCount = self.lineCoordinates.count
            guard let location = newLocation.last, let mapView else { return }
            if let lastData = self.lineCoordinates.last, lastData == location.coordinate { return }
            
            self.lineCoordinates.append(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            self.lineAnnotation = PolylineAnnotation(lineCoordinates: self.lineCoordinates)
            self.lineAnnotation.lineColor = StyleColor(UIColor.main)
            self.lineAnnotation.lineWidth = 5
            self.lineAnnotation.lineJoin = .round
            self.lineAnnotationManager.annotations = [self.lineAnnotation]
            
            // 좌표가 2개이상 존재하는경우 이동거리 업데이트
            if dataCount > 1 {
                self.distance += self.lineAnnotation.lineString.distance(from: self.lineCoordinates[dataCount - 2], to: self.lineCoordinates[dataCount - 1]) ?? 0
            }
            
            mapView.camera.ease(
                to: CameraOptions(center: location.coordinate, zoom: 17, bearing: 0),
                duration: 1.3)
        })
    }
    
    
    // 기록중지
    func stopTracking() {
        timerHandler?.cancel()
        self.locationTrackingCancellation = nil
    }
    
    // 운동정보 계산
    @MainActor
    func updateExcerciseData() {
        // 칼로리 계산
        let weightFactor = Double(authViewModel.userInfo.weight ?? 70) * 0.035
        let distanceFactor = self.distance * 0.029
        let durationFactor = self.elapsedTime / 60 * 0.012
        self.calorie = weightFactor + distanceFactor + durationFactor
        
        // 페이스 계산
        self.pace = (self.elapsedTime / 60) / (self.distance / 1000.0)
    }
    
}
