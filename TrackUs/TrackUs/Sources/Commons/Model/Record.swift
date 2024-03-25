//
//  Record.swift
//  TrackUs
//
//  Created by 석기권 on 3/25/24.
//

import Foundation
import MapboxMaps

struct Record: Hashable {
    let calorie: Double
    let distance: Double
    let elapsedTime: Double
    let pace: Double
    let coordinates: [CLLocationCoordinate2D]
    
    var identifier: String {
        return UUID().uuidString
    }
    public static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
}
