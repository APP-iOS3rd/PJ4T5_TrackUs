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
final class CourseRegViewModel: ObservableObject {
    enum CustomError: Error {
        case networkError
        case locationError
        case snapshotError
    }
    
    let id = UUID()
    
    private let authViewModel = AuthenticationViewModel.shared
    private let chatVieModle = ChatListViewModel.shared
    private let locationManager = LocationManager.shared
    private let MAXIMUM_NUMBER_OF_MARKERS: Int = 50
    
    @Published var style: RunningStyle = .walking
    @Published var coorinates = [CLLocationCoordinate2D]()
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedDate: Date?
    @Published var estimatedTime: Double = 0
    @Published var estimatedCalorie: Double = 0
    @Published var numberOfPeople: Int = 2
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
}

// MARK: - UI Update 🎨
extension CourseRegViewModel {
    var distance: Double {
        self.coorinates.caculateTotalDistance()
    }
    
    /// 경로 추가
    @MainActor
    func addPath(with coordinate: CLLocationCoordinate2D) {
        guard self.coorinates.count < MAXIMUM_NUMBER_OF_MARKERS else { return }
        self.coorinates.append(coordinate)
        self.updateCourseInfo()
    }
    
    /// 경로 제거
    @MainActor
    func removePath() {
        guard coorinates.count > 0 else { return }
        self.coorinates.removeAll()
        self.estimatedCalorie = 0
        self.estimatedTime = 0
    }
    
    /// 경로 되돌리기
    @MainActor
    func revertPath() {
        let _ = self.coorinates.popLast()
        self.updateCourseInfo()
    }
    
    /// 참여인원 설정
    @MainActor
    func addParticipants() {
        guard numberOfPeople < 10 else { return }
        self.numberOfPeople += 1
    }
    
    @MainActor
    func removeParticipants() {
        guard numberOfPeople > 2 else { return }
        self.numberOfPeople -= 1
    }
    
    /// 운동정보 업데이트
    @MainActor
    func updateCourseInfo() {
        self.estimatedCalorie = ExerciseManager.calculatedCaloriesBurned(distance: distance)
        self.estimatedTime = ExerciseManager.calculateEstimatedTime(distance: distance, style: self.style)
    }
    
    /// 시간포맷 동기화
    @MainActor
    func matchTimeFormat() {
        self.hours = estimatedTime.secondsInHours
        self.minutes = estimatedTime.secondsInMinutes
        self.seconds = estimatedTime.seconds
    }
}

// MARK: - Network Requests 🌐
extension CourseRegViewModel {
    
    @MainActor
    func uploadCourseData(completion: @escaping (Result<CourseViewModel, CourseRegViewModel.CustomError>) -> ()) {
        guard let image = self.image else {
            completion(.failure(.snapshotError))
            return
        }
        guard let startCoordinate = self.coorinates.first else {
            completion(.failure(.locationError))
            return
        }
        
        self.isLoading = true
        let uid = authViewModel.userInfo.uid
        let documentID = UUID().uuidString
        
        locationManager.convertToAddressWith(coordinate: startCoordinate.asCLLocation()) { address in
            
            ImageUploader.uploadImage(image: image, type: .map) { url in
                defer {
                    self.isLoading = false
                }
                let data: [String: Any] = [
                    "uid": documentID,
                    "ownerUid": uid,
                    "title": self.title,
                    "content": self.content,
                    "runningStyle": self.style.rawValue,
                    "members": [uid],
                    "routeImageUrl": url,
                    "address": address,
                    "numberOfPeople": self.numberOfPeople,
                    "startDate": self.selectedDate ?? Date(),
                    "distance": self.coorinates.caculateTotalDistance(),
                    "estimatedTime": self.estimatedTime,
                    "estimatedCalorie": self.estimatedCalorie,
                    "courseRoutes": self.coorinates.map {GeoPoint(latitude: $0.latitude, longitude: $0.longitude)},
                    "createdAt": Date()
                ]
                
                Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(documentID).setData(data) { error in
                    completion(.failure(.networkError))
                }
                
                // 채팅방 생성
                self.chatVieModle.createGroupChatRoom(trackId: documentID, title: self.title, uid: uid)
                
                // 완료 핸들러 -> 채팅방 이동
                completion(.success(CourseViewModel(course:
                                                        Course(uid: documentID,
                                                               ownerUid: uid,
                                                               title: self.title,
                                                               content: self.content,
                                                               courseRoutes: self.coorinates.map {GeoPoint(latitude: $0.latitude, longitude: $0.longitude)},
                                                               distance: self.distance,
                                                               estimatedTime: self.estimatedTime, numberOfPeople: self.numberOfPeople, runningStyle: self.style.rawValue, startDate: self.selectedDate ?? Date(), members: [uid],
                                                               routeImageUrl: url,
                                                               address: address,
                                                               estimatedCalorie: self.estimatedCalorie)
                                                   )))
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
