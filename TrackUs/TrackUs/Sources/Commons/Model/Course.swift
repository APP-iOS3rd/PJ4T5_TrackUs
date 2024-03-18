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
    let uid: String
    let ownerUid: String
    let title: String
    let content: String
    let courseRoutes: [GeoPoint]
    let distance: Double
    let estimatedTime: Double
    let participants: Int
    let runningStyle: String
    let startDate: Date
    var members: [String]
    let routeImageUrl: String
    let address: String
    let estimatedCalorie: Double
    
    var coordinates: [CLLocationCoordinate2D] {
        self.courseRoutes.map {CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
    }
}
