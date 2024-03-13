//
//  Course.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import FirebaseFirestoreSwift
import Firebase
import MapboxMaps

struct Course: Decodable, Hashable {
    @DocumentID var id: String?
    var uid: String = UUID().uuidString
    var ownerUid: String = ""
    var title: String = ""
    var content: String = ""
    var courseRoutes: [GeoPoint] = []
    var distance: Double = 0.0
    var estimatedTime: Double = 0.0
    var participants: Int = 0
    var runningStyle: String = ""
    var startDate: Date = Date()
    var members: [String] = []
    var routeImageUrl: String = ""
    var address: String = ""
    var estimatedCalorie: Double = 0.0
    
    var coordinates: [CLLocationCoordinate2D] {
        self.courseRoutes.map {CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
    }
}
