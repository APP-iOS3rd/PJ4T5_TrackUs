//
//  CourseRegViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import MapboxMaps

/**
 코스등록 정보 뷰모델
 */
class CourseRegViewModel: ObservableObject {
    let id = UUID()
    @Published var coorinates = [CLLocationCoordinate2D]()
    
    // 경로 추가
    func addPath(with coordinate: CLLocationCoordinate2D) {
        self.coorinates.append(coordinate)
    }
    
    // 경로 제거
    func removePath() {
        guard coorinates.count > 0 else { return }
        self.coorinates.removeAll()
    }
    
    func revertPath() {
        self.coorinates.popLast()
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
