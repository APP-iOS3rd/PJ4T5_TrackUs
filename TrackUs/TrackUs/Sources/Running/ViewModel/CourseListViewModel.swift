//
//  CourseListViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/26.
//

import Foundation

class CourseListViewModel: ObservableObject {
    let id = UUID()
    @Published var courseList = [Course]()
    private let authViewModel = AuthenticationViewModel.shared
    
    init() {
        fetchCourseData()
    }
    
    /// 모집글 데이터 가져오기
    func fetchCourseData() {
        Constants.FirebasePath.COLLECTION_GROUP_RUNNING.limit(to: 10).order(by: "createdAt", descending: true).getDocuments { snapShot, error in
            guard let documents = snapShot?.documents else { return }
            self.courseList = documents.compactMap  {(try? $0.data(as: Course.self))}
        }
    }
    
    /// 참여중인 러닝목록 가져오기
    @MainActor
    func filterdCourseData() -> [Course] {
        let uid = authViewModel.userInfo.uid
        return courseList.filter { $0.members.contains(uid) }
    }
}

extension CourseListViewModel: Hashable {
    static func == (lhs: CourseListViewModel, rhs: CourseListViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
