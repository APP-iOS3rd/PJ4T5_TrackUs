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
    @Published var mapView: MapView!
    @Published var elapsedTime: Double = 0
    @Published var timer = Timer.publish(every: 1, on: .main, in: .default)
    @Published var timerHandler: Cancellable?
    
    // 맵뷰 초기설정
    func setupMapView(frame: CGRect) {
        guard let coordinate = locationManager.currentLocation?.coordinate else { return }
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), zoom: 17)
        let myMapInitOptions = MapInitOptions(cameraOptions: cameraOptions)
        self.mapView = MapView(frame: frame, mapInitOptions: myMapInitOptions)
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapView.mapboxMap.styleURI = .light
        
        self.mapView.location.options.puckType = .puck2D()
        self.mapView.location.options.puckBearingEnabled = true
    }
    
    // 추적시작
    func startTracking() {
        timer = Timer.publish(every: 1, on: .main, in: .default)
        timerHandler = timer.connect()
        self.locationTrackingCancellation = mapView.location.onLocationChange.observe({ [weak mapView] newLocation in
            guard let location = newLocation.last, let mapView else { return }
            
            mapView.camera.ease(
                to: CameraOptions(center: location.coordinate, zoom: 17, bearing: 0),
                duration: 1.5)
        })
    }
    
    
    // 추적종료
    func stopTracking() {
        timerHandler?.cancel()
        self.locationTrackingCancellation = nil
    }
}
