//
//  TrackingViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/19.
//

import UIKit
import Combine
// 3초 카운트 종료 -> isPause = ture => false
// 러닝 일시중지 -> isPause = true
// 뷰 -> isPause 구독
class TrackingViewModel: ObservableObject {
    @Published var count: Int = 3
    @Published var isPause: Bool = true
    var timer: Timer = Timer()
    
    init() {
        initTimer()
    }
    
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
    
}
