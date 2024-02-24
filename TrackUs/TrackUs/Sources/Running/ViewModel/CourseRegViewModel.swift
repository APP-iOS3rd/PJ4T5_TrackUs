//
//  CourseRegViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import MapboxMaps
import Firebase
/**
 코스등록 정보 뷰모델
 */
class CourseRegViewModel: ObservableObject {
    private let authViewModel = AuthenticationViewModel.shared
    let id = UUID()
    let MAXIMUM_NUMBER_OF_MARKERS: Int = 30
    
    @Published var style: RunningStyle = .walking
    @Published var coorinates = [CLLocationCoordinate2D]()
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedDate: Date?
    @Published var estimatedTime: Int = 0
    @Published var distance: Double = 0
    @Published var participants: Int = 1
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    @Published var image: UIImage?
    
    
    // 경로 추가
    func addPath(with coordinate: CLLocationCoordinate2D) {
        guard self.coorinates.count < MAXIMUM_NUMBER_OF_MARKERS else { return }
        self.coorinates.append(coordinate)
    }
    
    // 경로 제거
    func removePath() {
        guard coorinates.count > 0 else { return }
        self.coorinates.removeAll()
    }
    
    // 경로 되돌리기
    func revertPath() {
        self.coorinates.popLast()
    }
    
    // 참여인원 설정
    func addParticipants() {
        guard participants < 10 else { return }
        self.participants += 1
    }
    
    func removeParticipants() {
        guard participants > 1 else { return }
        self.participants -= 1
    }
    
    @MainActor
    func uploadCourseData() {
        let uid = authViewModel.userInfo.uid
        guard let image = self.image else { return }
        ImageUploader.uploadImage(image: image, type: .map) { url in
            let data: [String: Any] = [
                "uid": UUID().uuidString,
                "ownerUid": uid,
                "title": self.title,
                "content": self.content,
                "startDate": self.selectedDate ?? Date(),
                "distance": self.distance,
                "participants": self.participants,
                "estimatedTime": (self.hours * 3600) + (self.minutes * 60) + (self.seconds),
                "runningStyle": self.style.rawValue,
                "members": [uid],
                "courseRoutes": self.coorinates.map {GeoPoint(latitude: $0.latitude, longitude: $0.longitude)},
                "routeImageUrl": url
            ]
            Constants.FirebasePath.COLLECTION_GROUP_RUNNING.addDocument(data: data) { _ in
                
            }
        }
    }
}

extension CourseRegViewModel: Hashable {
    static func == (lhs: CourseRegViewModel, rhs: CourseRegViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
