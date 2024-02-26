//
//  CourseViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/26.
//
import Foundation

class CourseViewModel: ObservableObject {
    let id = UUID()
    private let authViewModel = AuthenticationViewModel.shared
    @Published var course: Course
    
    
    init(course: Course) {
        self.course = course
    }
    
    /// 러닝 참여하기
    @MainActor
    func addParticipant() {
        let uid = self.course.uid
        let memberUid = authViewModel.userInfo.uid
        
        Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).getDocument { snapShot, error in
            guard let document = try? snapShot?.data(as: Course.self) else { return }
            Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).updateData(["members":document.members + [memberUid]]) { _ in
                self.course.members.append(memberUid)
            }
        }
    }
    
    @MainActor
    func removeParticipant() {
        let uid = self.course.uid
        let memberUid = authViewModel.userInfo.uid
        
        Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).getDocument { snapShot, error in
            guard var document = try? snapShot?.data(as: Course.self) else { return }
            
            Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).updateData(["members":document.members.filter {$0 != memberUid}]) { _ in
                self.course.members = self.course.members.filter { $0 != memberUid }
            }
        }
    }
    
    // 러닝 삭제
    func removeCourse(completion: @escaping () -> ()) {
        let uid = self.course.uid
        
        Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).delete { error in
            completion()
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