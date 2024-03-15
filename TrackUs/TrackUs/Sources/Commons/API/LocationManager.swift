//
//  LocationManager.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import Foundation
import CoreLocation
import MapboxMaps

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
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
    
    // 위도, 경도를 받아서 한글주소로 반환
    func convertToAddressWith(coordinate: CLLocation, completion: @escaping (String?) -> ()) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(coordinate) { placemarks, error in
            if error != nil {
                completion(nil)
                return
            }
            
            if let address: [CLPlacemark] = placemarks {
                let city = address.last?.administrativeArea
                let state = address.last?.subLocality
                
                if let city = city, let state = state {
                    completion("\(city) \(state)")
                } else if let city = city {
                    completion("\(city)")
                } else if let state = state {
                    completion("\(state)")
                } else {
                    completion("위치정보 없음")
                }
                
            }
        }
    }
}
