//
//  SettingPopupViewModel.swift
//  TrackUs
//
//  Created by 윤준성 on 2/8/24.
//

import Foundation
import SwiftUI

class SettingPopupViewModel: ObservableObject {
    @Published var showingPopup = false
    @Published var goalMinValue: Double
    @Published var estimatedTime: Int
    
    var authViewModel = AuthenticationViewModel.shared
    
    let goalMinValueKey = "GoalMinValue"
    let estimatedTimeKey = "EstimatedTime"
    
    init() {
        let defaults = UserDefaults.standard
        let savedGoalMinValue = defaults.double(forKey: goalMinValueKey)
        let savedEstimatedTime = defaults.integer(forKey: estimatedTimeKey)
        
        if savedGoalMinValue == 0 {
            self.goalMinValue = 3
        } else {
            self.goalMinValue = savedGoalMinValue
        }
        
        if savedEstimatedTime == 0 {
            self.estimatedTime = 15
        } else {
            self.estimatedTime = savedEstimatedTime
        }
    }
    
    @MainActor func updateEstimatedTime() {
        guard let runningStyle = authViewModel.userInfo.runningStyle
        
        else {
            estimatedTime = Int(goalMinValue * 10)
            return }
        
        switch runningStyle {
        case .walking:
            estimatedTime = Int(goalMinValue * 12)
        case .jogging:
            estimatedTime = Int(goalMinValue * 10)
        case .running:
            estimatedTime = Int(goalMinValue * 5)
        case .interval:
            estimatedTime = Int(goalMinValue * 4)
        }
    }

    
    func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(goalMinValue, forKey: goalMinValueKey)
        defaults.set(estimatedTime, forKey: estimatedTimeKey)
    }
}
