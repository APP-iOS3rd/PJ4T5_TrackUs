//
//  RunningRecord.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/14.
//

import Foundation
import MapboxMaps

struct RunningRecord: Hashable {
    let calorie: Double
    let distance: Double
    let elapsedTime: Double
    let pace: Double
    let coordinates: [CLLocationCoordinate2D]
    
    var paceMinutes: Int {
        Int(self.pace)
    }
    
    var paceSeconds: Int {
        Int((self.pace - Double(paceMinutes)) * 60)
    }
    
    var identifier: String {
        return UUID().uuidString
    }
    public static func == (lhs: RunningRecord, rhs: RunningRecord) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
}
