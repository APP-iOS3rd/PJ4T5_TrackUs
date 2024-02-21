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
    
    // 위도, 경도를 받아서 한글주소로 반환
    func convertToAddressWith(coordinate: CLLocation, completion: @escaping (String?) -> ()) {
        let geoCoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr")
        geoCoder.reverseGeocodeLocation(coordinate, preferredLocale: local) { placemarks, error in
            if error != nil {
                completion(nil)
                return
            }
            
            if let address: [CLPlacemark] = placemarks {
                guard let city = address.last?.administrativeArea, let state = address.last?.subLocality else {
                    completion(nil)
                    return
                }
                completion("\(city) \(state)")
            }
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
        print(averageLatitude, averageLongitude, "?")
        return CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
    }
}
