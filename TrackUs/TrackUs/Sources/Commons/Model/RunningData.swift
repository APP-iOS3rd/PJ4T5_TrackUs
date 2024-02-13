//
//  RunningData.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/13.
//

import Foundation
import MapboxMaps

struct RunningData: Hashable {
    let calorie: Double
    let coordinates: [CLLocationCoordinate2D]
    let distance: Double
    let elapsedTime: Double
    let pace: Double
    
    var paceMinutes: Int {
        Int(self.pace)
    }
    
    var paceSeconds: Int {
        Int((self.pace - Double(paceMinutes)) * 60)
    }
    
    var identifier: String {
        return UUID().uuidString
    }
    public static func == (lhs: RunningData, rhs: RunningData) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
}
