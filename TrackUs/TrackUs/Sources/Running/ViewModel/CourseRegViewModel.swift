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
    private let authViewModel = AuthenticationViewModel.shared
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
    let MAXIMUM_NUMBER_OF_MARKERS: Int = 30
    
    // 경로 추가
    func addPath(with coordinate: CLLocationCoordinate2D) {
        guard self.coorinates.count <= MAXIMUM_NUMBER_OF_MARKERS else { return }
        self.coorinates.append(coordinate)
    }
    
    // 경로 제거
    func removePath() {
        guard coorinates.count > 0 else { return }
        self.coorinates.removeAll()
    }
    
    // 경로 되돌리기
    func revertPath() {
        self.coorinates.popLast()
    }
    
    // 참여인원 설정
    func addParticipants() {
        guard participants < 10 else { return }
        self.participants += 1
    }
    
    func removeParticipants() {
        guard participants > 1 else { return }
        self.participants -= 1
    }
    
    
    func uploadCourseData() {
        
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
