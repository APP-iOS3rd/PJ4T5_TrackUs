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
    @Published var estimatedTime: Double
    
    var authViewModel = AuthenticationViewModel.shared
    
    let goalMinValueKey = "GoalMinValue"
    let estimatedTimeKey = "EstimatedTime"
    
    let DEFAULT_GOAL_DISTANCE = 3000.0
    let DEFAULT_ESTIMATED_TIME = 900.0
    
    init() {
        let defaults = UserDefaults.standard
        let savedGoalMinValue = defaults.double(forKey: goalMinValueKey)
        let savedEstimatedTime = defaults.double(forKey: estimatedTimeKey)
        
        if savedGoalMinValue == 0 {
            self.goalMinValue = DEFAULT_GOAL_DISTANCE
        } else {
            self.goalMinValue = savedGoalMinValue
        }
        
        if savedEstimatedTime == 0 {
            self.estimatedTime = DEFAULT_ESTIMATED_TIME
        } else {
            self.estimatedTime = savedEstimatedTime
        }
    }
    
    
    @MainActor 
    func updateEstimatedTime() {
        self.estimatedTime = ExerciseManager.calculateEstimatedTime(distance: self.goalMinValue)
    }
    
    
    func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(goalMinValue, forKey: goalMinValueKey)
        defaults.set(estimatedTime, forKey: estimatedTimeKey)
    }
}
