//
//  CourseViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/26.
//
import Foundation
import MapboxMaps
/**
  코스데이터에 대한 개별적인 뷰모델
 */
class CourseViewModel: ObservableObject {
    let id = UUID()
    private let authViewModel = AuthenticationViewModel.shared
    private let chatViewModel = ChatListViewModel.shared
    
    @Published var course: Course
    
    init(course: Course) {
        self.course = course
    }
}

// MARK: - UI관련 작업들
extension CourseViewModel {
    func addPath(with coordinate: CLLocationCoordinate2D) {
        course.courseRoutes.append(coordinate.toGeoPoint())
    }
}

// MARK: - 네트워크 요청관련
extension CourseViewModel {
    
    /// 러닝 참여요청
    @MainActor
    func addMember() {
        let uid = self.course.uid
        let memberUid = authViewModel.userInfo.uid
        
        Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).getDocument { snapShot, error in
            guard let document = try? snapShot?.data(as: Course.self) else { return }
            Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).updateData(["members":document.members + [memberUid]]) { _ in
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
        
        Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).getDocument { snapShot, error in
            guard let document = try? snapShot?.data(as: Course.self) else { return }
            
            Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).updateData(["members":document.members.filter {$0 != memberUid}]) { _ in
                self.course.members = self.course.members.filter { $0 != memberUid }
            }
        }
        // 채팅 나가기
        chatViewModel.leaveChatRoom(chatRoomID: uid, userUID: memberUid)
    }
    
    /// 러닝추가
    func addCourse() {
        
    }
    
    /// 러닝 삭제
    func removeCourse(completion: @escaping () -> ()) {
        let uid = self.course.uid
        
        chatViewModel.deleteChatRoom(chatRoomID: uid)
        Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).delete { error in
            completion()
        }
    }
    
    /// 러닝 수정
    func editCourse() {
        
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

