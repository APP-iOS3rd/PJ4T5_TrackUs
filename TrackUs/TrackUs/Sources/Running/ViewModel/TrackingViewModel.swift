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
    @Published var count: Int = 3 // 카운트다운
    @Published var isPause: Bool = true // 러닝기록 상태
    @Published var coordinates: [CLLocationCoordinate2D] = [] // 경로데이터
    @Published var distance: Double = 0.0 // 이동거리
    
    var timer: Timer = Timer()
    
    init() {
        initTimer()
    }
    
    // 초기타이머
    func initTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            count -= 1
            if count == 0 {
                self.isPause = false
                self.timer.invalidate()
            }
        })
    }
    
    // 경로데이터 업데이트 함수
    func updateCoordinates(with coordinate: CLLocationCoordinate2D) {
        self.coordinates.append(coordinate)
        guard self.coordinates.count > 1 else { return }
        
        let newLocation = self.coordinates[self.coordinates.count - 1]
        let oldLocation = self.coordinates[self.coordinates.count - 2]
        self.distance += newLocation.distance(to: oldLocation) / 1000.0
    }
}
