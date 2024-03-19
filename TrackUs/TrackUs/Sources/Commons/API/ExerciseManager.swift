//
//  ExerciseManager.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/20.
//

import Foundation

/**
 거리와 러닝스타일 기반으로 운동정보를 반환해주는 클래스
 */
final class ExerciseManager {
    
    /// 거리(m) -> 칼로리
    static func calculatedCaloriesBurned(distance: Double) -> Double {
        let caloriesPerKilometer: Double = 0.00075
        let weightInKilograms = 70.0
        let caloriesBurned = weightInKilograms * distance * caloriesPerKilometer
        
        return caloriesBurned
    }
    
    /// 시간(sec) -> 러닝 페이스
    static func calculatedPace(distance: Double, timeInSeconds: Double) -> Double {
        let pace = timeInSeconds / distance
        
        return pace
    }
    
    /// 거리(m) + 러닝스타일 -> 예상시간(sec)
    /// 거리(m)  * m당 평균 소요시간(러닝스타일)
    @MainActor
    static func calculateEstimatedTime(distance: Double, style: RunningStyle? = nil) -> Double {
        let runningStyle = style ?? (AuthenticationViewModel.shared.userInfo.runningStyle ?? .jogging)
        
        switch runningStyle {
        case .walking:
            return distance * 0.9
        case .jogging:
            return distance * 0.45
        case .running:
            return distance * 0.3
        case .interval:
            return distance * 0.15
        }
    }
}


