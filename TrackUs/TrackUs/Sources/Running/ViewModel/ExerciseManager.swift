//
//  ExerciseManager.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/20.
//

import Foundation

// 운동정보를 계산하는 유틸클래스
final class ExerciseManager {
    @MainActor
    static func calculatedCaloriesBurned(distance: Double, totalTime: Double) -> Double {
        let userInfo = AuthenticationViewModel.shared.userInfo
        let gender = userInfo.gender ?? true // t = male, f = female
        let MALE_AVG_HEIGHT = 171, MALE_AVG_WEIGHT = 72, FEMALE_AVG_HEIGHT = 158, FEMALE_AVG_WEIGHT = 57
        
        var bmr: Double = 0.0
        
        let myHeight = userInfo.height ?? (gender ? MALE_AVG_HEIGHT : FEMALE_AVG_HEIGHT)
        let myWeight = userInfo.weight ?? (gender ? MALE_AVG_WEIGHT : FEMALE_AVG_WEIGHT)
        let myAge = userInfo.age ?? 20
        
        if gender { bmr =  88.362 + (13.397 * Double(myWeight)) + (4.799 * Double(myHeight)) - (5.677 * Double(myAge)) }
        else { bmr = 447.593 + (9.247 * Double(myWeight)) + (3.098 * Double(myHeight)) - (4.330 * Double(myAge)) }
        
        let tdee: Double
        
        let activityMultiplier: Double = 1.55

        tdee = bmr * activityMultiplier
        
        let runningMET: Double = 8.0
        
        let caloriesBurned = runningMET * (Double(myWeight) / 2.20462) * (totalTime / 60.0)
        
        let totalCaloriesBurned = caloriesBurned + tdee
        
        return totalCaloriesBurned
    }
}


