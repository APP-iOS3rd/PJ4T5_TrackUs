//
//  CourseViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import Foundation

class CourseViewModel: ObservableObject {
    let id = UUID()
    @Published var courseList = [Course]()
    private let authViewModel = AuthenticationViewModel.shared
    
    init() {
        fetchCourseData()
    }
    
    /// 모집글 데이터 가져오기
    func fetchCourseData() {
        Constants.FirebasePath.COLLECTION_GROUP_RUNNING.getDocuments { snapShot, error in
            guard let documents = snapShot?.documents else { return }
            self.courseList = documents.compactMap  {(try? $0.data(as: Course.self))}
        }
    }
    
    /// 러닝 참여하기
    @MainActor
    func addParticipant(uid: String) {
        let memberUid = authViewModel.userInfo.uid
        
        Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).getDocument { snapShot, error in
            guard let document = try? snapShot?.data(as: Course.self) else { return }
            Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).updateData(["members":document.members + [memberUid]]) { _ in
                  
            }
        }
    }
    
    @MainActor
    func removeParticipant(uid: String) {
        let memberUid = authViewModel.userInfo.uid
        Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).getDocument { snapShot, error in
            guard var document = try? snapShot?.data(as: Course.self) else { return }
            
            Constants.FirebasePath.COLLECTION_GROUP_RUNNING.document(uid).updateData(["members":document.members.filter {$0 != memberUid}]) { _ in
              
            }
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
