//
//  Course.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase
import MapboxMaps

/**
 uid: 모집글에대한 uid
 ownerUid: 게시한 유저의 uid
 title: 글제목
 content: 글내용
 courseRoutes: 러닝경로
 distance: 예상거리
 estimatedTime: 예상 소요시간
 estimatedCalorie: 소모칼로리
 numberOfPeople: 최대인원
 runningStyle: 러닝스타일
 startDate: 시작일
 members: 멤버목록(uid)
 routeImageUrl: 경로이미지 URL
 address: 주소 텍스트
 */

struct Course: Codable, Hashable {
    @DocumentID var id: String?
    let uid: String
    var ownerUid: String
    var title: String
    var content: String
    var courseRoutes: [GeoPoint]
    var distance: Double
    var estimatedTime: Double
    var numberOfPeople: Int
    var runningStyle: String
    var startDate: Date?
    var members: [String]
    var routeImageUrl: String
    var address: String
    var estimatedCalorie: Double
    var createdAt: Date?
    var isEdit = false
    
    /// 데이터생성(데이터전송용)
    static func createObject() -> Course {
        Course(
            uid: UUID().uuidString,
            ownerUid: "",
            title: "",
            content: "",
            courseRoutes: [],
            distance: 0,
            estimatedTime: 0,
            numberOfPeople: 2,
            runningStyle: RunningStyle.walking.rawValue,
            startDate: Date(),
            members: [],
            routeImageUrl: "",
            address: "",
            estimatedCalorie: 0,
            createdAt: nil,
            isEdit: false
        )
    }
    
    var coordinates: [CLLocationCoordinate2D] {
        self.courseRoutes.map {CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
    }
}



