//
//  CourseCellViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/25.
//

import Foundation

class CourseCellViewModel: ObservableObject {
    @Published var course: Course
    
    init(course: Course) {
        self.course = course
    }
}
