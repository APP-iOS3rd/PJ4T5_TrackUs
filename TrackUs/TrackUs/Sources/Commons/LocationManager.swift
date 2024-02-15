//
//  LocationManager.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import Foundation
import CoreLocation
import MapboxMaps

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    @Published var isUpdatingLocation: Bool = false
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        // 위치 정확도 최고 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        
        getCurrentLocation()
    }
    
    
    
    func getCurrentLocation() {
        locationManager.startUpdatingLocation()
        currentLocation = locationManager.location
    }
    
    func checkLocationServicesEnabled(_ completion: @escaping (CLAuthorizationStatus) -> Void) {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways:
            completion(.authorizedAlways)
        case .notDetermined:
            completion(.notDetermined)
        case .authorizedWhenInUse:
            completion(.authorizedWhenInUse)
        case .restricted:
            completion(.restricted)
        case .denied:
            completion(.denied)
        }
    }
}
