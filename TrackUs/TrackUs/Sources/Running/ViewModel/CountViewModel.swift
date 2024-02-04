//
//  CountViewModel.swift
//  TrackUs
//
//  Created by 윤준성 on 2/5/24.
//

import SwiftUI

class CountViewModel: ObservableObject {
    @Published var countdown: Int = 3
    @Published var isHidden: Bool = false
    @Published var backgroundOpacity: Double = 0.31

    func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { timer in
            withAnimation {
                if self.countdown > 1 {
                    self.countdown -= 1
                } else {
                    self.isHidden = true
                    timer.invalidate()
                }
            }
        }
    }
}
