//
//  Course.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

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

struct Course: Decodable, Hashable {
    @DocumentID var id: String?
    let uid: String
    let ownerUid: String
    let title: String
    let content: String
    var courseRoutes: [GeoPoint]
    let distance: Double
    let estimatedTime: Double
    let numberOfPeople: Int
    let runningStyle: String
    let startDate: Date
    var members: [String]
    let routeImageUrl: String
    let address: String
    let estimatedCalorie: Double
    
    /// 데이터생성(데이터전송용)
    static func createObject() -> Course {
        Course(
            uid: "",
            ownerUid: "",
            title: "",
            content: "",
            courseRoutes: [],
            distance: 0,
            estimatedTime: 0,
            numberOfPeople: 0,
            runningStyle: "",
            startDate: Date(),
            members: [],
            routeImageUrl: "",
            address: "",
            estimatedCalorie: 0)
    }
    
    var toCoordinates: [CLLocationCoordinate2D] {
        self.courseRoutes.map {CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
    }
}



