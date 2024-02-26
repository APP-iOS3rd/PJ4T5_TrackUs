//
//  ExerciseManager.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/20.
//

import Foundation

final class ExerciseManager {
    
    // 칼로리 계산로직(임시)
    static func calculatedCaloriesBurned(distance: Double) -> Double {
        let caloriesPerKilometer: Double = 0.75
        let weightInKilograms = 70.0
        let caloriesBurned = weightInKilograms * distance * caloriesPerKilometer
        
        return caloriesBurned
    }
    
    // 페이스(pace) -> 1km를 가는데 걸리는 시간
    // 5km 이동 30분 소요 = 30/5 = 6min/km
    static func calculatedPace(distance: Double, totalTime: Double) -> Double {
        let timeInMinutes = totalTime / 60.0
        let pace = timeInMinutes / distance
        
        return pace
    }
    
    // 예상시간 계산
    @MainActor
    static func calculateEstimatedTime(distance: Double) -> Int {
        let runningStyle = AuthenticationViewModel.shared.userInfo.runningStyle ?? .jogging
        
        switch runningStyle {
        case .walking:
            return Int(distance * 12)
        case .jogging:
            return Int(distance * 10)
        case .running:
            return Int(distance * 5)
        case .interval:
            return Int(distance * 4)
        }
    }
}