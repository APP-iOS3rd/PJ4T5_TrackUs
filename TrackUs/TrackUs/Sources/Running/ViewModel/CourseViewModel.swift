//
//  CourseViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import Foundation

class CourseViewModel: ObservableObject {
    @Published var courseList = [Course]()
    
    init() {
        fetchCourseData()
    }
    
    // 모집글 데이터 가져오기
    func fetchCourseData() {
        Constants.FirebasePath.COLLECTION_GROUP_RUNNING.getDocuments { snapShot, error in
            guard let documents = snapShot?.documents else { return }
            self.courseList = documents.compactMap  {(try? $0.data(as: Course.self))}
        }
    }
}
