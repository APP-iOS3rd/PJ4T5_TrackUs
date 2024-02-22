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
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedDate: Date?
    @Published var estimatedTime: Int = 0
    @Published var participants: Int = 1
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    @Published var style: RunningStyle = .walking
    
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
    
    func addParticipants() {
        guard participants < 10 else { return }
        self.participants += 1
    }
    
    func removeParticipants() {
        guard participants > 1 else { return }
        self.participants -= 1
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
