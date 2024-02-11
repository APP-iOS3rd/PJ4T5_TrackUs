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
    let locationManager = LocationManager.shared
    private var locationTrackingCancellation: AnyCancelable?
    private var lineCoordinates: [CLLocationCoordinate2D] = []
    private var lineAnnotation: PolylineAnnotation!
    private var lineAnnotationManager: PolylineAnnotationManager!
    private var puckConfiguration = Puck2DConfiguration.makeDefault()
    @Published var mapView: MapView!
    @Published var elapsedTime: Double = 0
    @Published var timer = Timer.publish(every: 1, on: .main, in: .default)
    @Published var timerHandler: Cancellable?
    @Published var distance: Double = 0
    @Published var calorie: Double = 0
    @Published var pace = 0
    
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
    }
    
    // 기록시작
    func startTracking() {
        // 타이머 활성화
        timer = Timer.publish(every: 1, on: .main, in: .default)
        timerHandler = timer.connect()
        
        // TODO: - 이동거리 범위가 적은 경우 경로에 추가하지 않기
        self.locationTrackingCancellation = mapView.location.onLocationChange.observe({ [weak mapView] newLocation in
            guard let location = newLocation.last, let mapView else { return }
            // 이동거리 경로 레이아웃
            self.lineCoordinates.append(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            self.lineAnnotation = PolylineAnnotation(lineCoordinates: self.lineCoordinates)
            self.lineAnnotation.lineColor = StyleColor(UIColor.main)
            self.lineAnnotation.lineWidth = 5
            self.lineAnnotation.lineJoin = .round
            self.lineAnnotationManager.annotations = [self.lineAnnotation]
            
            // 좌표가 2개이상 존재하는경우 이동거리, 소모 칼로리 업데이트
            if self.lineCoordinates.count > 1 {
                self.distance += self.moveDistance(coord1: self.lineCoordinates[self.lineCoordinates.count - 2], coord2: self.self.lineCoordinates[self.lineCoordinates.count - 1])
                self.calorie = self.calorieBurned()
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
    
    // 위도, 경도를 이용하여 거리계산 함수(임시)
    func moveDistance(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Double {
        let R = 6371000.0
        
        let lat1 = coord1.latitude.radians
        let lon1 = coord1.longitude.radians
        let lat2 = coord2.latitude.radians
        let lon2 = coord2.longitude.radians
        
        let dLat = lat2 - lat1
        let dLon = lon2 - lon1
        
        let a = sin(dLat / 2.0) * sin(dLat / 2.0) + cos(lat1) * cos(lat2) * sin(dLon / 2.0) * sin(dLon / 2.0)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        let distanceInMeters = R * c
        
        return distanceInMeters
    }
    
    // 칼로리 계산(임시)
    func calorieBurned() -> Double {
        return 70 * self.distance / 1000 * 0.75
    }
}
