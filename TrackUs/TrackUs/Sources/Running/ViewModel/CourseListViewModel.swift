//
//  CourseListViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/26.
//

import Foundation

class CourseListViewModel: ObservableObject {
    let id = UUID()
    private let authViewModel = AuthenticationViewModel.shared
    
    @Published var courseList = [Course]()
    
    @MainActor
    var myCourseData: [Course] {
        let uid = authViewModel.userInfo.uid
        return courseList.filter { $0.members.contains(uid) }
    }
    
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
    
    
    /// 코스데이터 찾기
    func findCourseWithUID(_ uid: String) -> Course? {
        return courseList.filter { $0.uid == uid }.first
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
