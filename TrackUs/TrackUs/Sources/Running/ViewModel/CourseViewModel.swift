//
//  CourseViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/26.
//

import UIKit
import MapboxMaps
/**
  코스데이터에 대한 개별적인 뷰모델
 */
class CourseViewModel: ObservableObject {
    enum ErrorType: Error {
        case fetchError
    }
    let id = UUID()
    private let authViewModel = AuthenticationViewModel.shared
    private let chatViewModel = ChatListViewModel.shared
    private let locationManager = LocationManager.shared
    
    @Published var course: Course
    @Published var uiImage: UIImage?
    @Published var isLoading = false
    
    init(course: Course) {
        self.course = course
    }
}

// MARK: - UI관련 작업들
extension CourseViewModel {
    
    /// 지도에 경로를 추가
    @MainActor
    func addPath(with coordinate: CLLocationCoordinate2D) {
        course.courseRoutes.append(coordinate.toGeoPoint())
        updateInfoWithPath()
    }
    
    /// 경로 되돌리기
    @MainActor
    func revertPath() {
      let _ = course.courseRoutes.popLast()
        updateInfoWithPath()
    }
    
    /// 지동상의 모든 경로를 제거
    @MainActor
    func removePath() {
        course.courseRoutes.removeAll()
    }
    
    /// 인원설정
    @MainActor
    func increasePeople() {
        guard course.numberOfPeople < 10 else { return }
        course.numberOfPeople += 1
    }
    
    @MainActor
    func decreasePeople() {
        guard course.numberOfPeople > 2 else { return }
        course.numberOfPeople -= 1
    }
    
    /// 경로추가 -> 시간, 칼로리, 거리 업데이트
    @MainActor
    func updateInfoWithPath() {
        course.estimatedTime = ExerciseManager.calculateEstimatedTime(distance: course.distance, style: .init(rawValue: course.runningStyle))
        course.estimatedCalorie = ExerciseManager.calculatedCaloriesBurned(distance: course.distance)
        course.distance = course.courseRoutes.toCLLocationCoordinate2D().caculateTotalDistance()
    }
}

// MARK: - 네트워크 요청관련
extension CourseViewModel {
    
    /// 러닝 참여요청
    @MainActor
    func addMember() {
        let uid = self.course.uid
        let memberUid = authViewModel.userInfo.uid
        
        Constants.FirebasePath.COLLECTION_RUNNING.document(uid).getDocument { snapShot, error in
            guard let document = try? snapShot?.data(as: Course.self) else { return }
            Constants.FirebasePath.COLLECTION_RUNNING.document(uid).updateData(["members":document.members + [memberUid]]) { _ in
                self.course.members.append(memberUid)
            }
        }
        chatViewModel.joinChatRoom(chatRoomID: uid, userUID: memberUid)
    }
    
    /// 러닝참여 취소하기
    @MainActor
    func removeMember() {
        let uid = self.course.uid
        let memberUid = authViewModel.userInfo.uid
        
        Constants.FirebasePath.COLLECTION_RUNNING.document(uid).getDocument { snapShot, error in
            guard let document = try? snapShot?.data(as: Course.self) else { return }
            
            Constants.FirebasePath.COLLECTION_RUNNING.document(uid).updateData(["members":document.members.filter {$0 != memberUid}]) { _ in
                self.course.members = self.course.members.filter { $0 != memberUid }
            }
        }
        // 채팅 나가기
        chatViewModel.leaveChatRoom(chatRoomID: uid, userUID: memberUid)
    }
    
    /// 러닝추가
    @MainActor
    func addCourse(_ completion: @escaping (Result<Course, ErrorType>) -> ()) {
        isLoading = true
        guard let startLocation = course.courseRoutes.first?.asCLLocation else { return }
        guard let image = uiImage else { return }
        
        let user = authViewModel.userInfo.uid
        course.ownerUid = user
        course.members = [user]
        
        locationManager.convertToAddressWith(coordinate: startLocation) { address in
            ImageUploader.uploadImage(image: image, type: .map) { url in
                self.course.routeImageUrl = url
                self.course.address = address
                self.course.createdAt = Date()
                self.course.isEdit = true
                
                self.chatViewModel.createGroupChatRoom(
                    trackId: self.course.uid,
                    title: self.course.title,
                    uid: user)
                
                do {
                   try Constants.FirebasePath.COLLECTION_RUNNING.document(self.course.uid).setData(from: self.course)
                       completion(.success(self.course))
                } catch {
                    print(#function + "Failed upload data")
                    completion(.failure(.fetchError))
                }
                self.isLoading = false
            }
        }
    }
    
    /// 러닝 삭제
    func removeCourse(completion: @escaping () -> ()) {
        let uid = self.course.uid
        
        chatViewModel.deleteChatRoom(chatRoomID: uid)
        Constants.FirebasePath.COLLECTION_RUNNING.document(uid).delete { error in
            completion()
        }
    }
    
    /// 러닝 수정
    func editCourse(_ completion: @escaping (Result<Course, ErrorType>) -> ()) {
        do {
           try Constants.FirebasePath.COLLECTION_RUNNING.document(self.course.uid).setData(from: self.course)
            completion(.success(self.course))
        } catch {
            print(#function + "Failed upload data")
            completion(.failure(.fetchError))
        }
    }
}

extension CourseViewModel: Hashable {
    static func == (lhs: CourseViewModel, rhs: CourseViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
