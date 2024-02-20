//
//  TrackingViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/19.
//

import UIKit
import Combine
import SwiftUI
import MapboxMaps

// 위치변화 감지 -> 위치값 저장 -> 저장된 위치값을 경로에 그려주기(뷰컨에서 구독)
class TrackingViewModel: ObservableObject {
    private let id = UUID()
    private let authViewModel = AuthenticationViewModel.shared
    @Published var count: Int = 3 // 카운트다운
    @Published var isPause: Bool = true // 러닝기록 상태
    // 러닝기록(넘겨주는 데이터)
    @Published var coordinates: [CLLocationCoordinate2D] = []
    @Published var distance: Double = 0.0
    @Published var elapsedTime: Double = 0.0
    @Published var calorie: Double = 0.0
    @Published var pace: Double = 0.0
    
    var countTimer: Timer = Timer()
    var recordTimer: Timer = Timer()
    
    init() {
        initTimer()
    }
    
    // 카운트다운
    func initTimer() {
        self.countTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            count -= 1
            if count == 0 {
                self.countTimer.invalidate()
            }
        })
    }
    
    // 경로데이터 업데이트 함수
    @MainActor
    func updateCoordinates(with coordinate: CLLocationCoordinate2D) {
        self.coordinates.append(coordinate)
        
        guard self.coordinates.count > 1 else { return }
        
        let newLocation = self.coordinates[self.coordinates.count - 1]
        let oldLocation = self.coordinates[self.coordinates.count - 2]
        
        self.distance += (newLocation.distance(to: oldLocation)) / 1000.0
        self.calorie = ExerciseManager.calculatedCaloriesBurned(distance: self.distance, totalTime: self.elapsedTime)
        self.pace = ExerciseManager.calculatedPace(distance: self.distance, totalTime: self.elapsedTime)
    }
    
    // 기록시작
    func startRecord() {
        self.isPause = false
        self.recordTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 1
        })
    }
    
    // 기록중지
    func stopRecord() {
        self.isPause = true
        self.recordTimer.invalidate()
    }
}

extension TrackingViewModel: Hashable {
    static func == (lhs: TrackingViewModel, rhs: TrackingViewModel) -> Bool {
           lhs.id == rhs.id
       }
       
       func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
}

