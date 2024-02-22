//
//  CLLocation+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import MapboxMaps

extension CLLocation {
    func asCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
}
