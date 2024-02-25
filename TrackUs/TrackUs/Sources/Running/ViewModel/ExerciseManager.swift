//
//  ExerciseManager.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/20.
//

import Foundation

/** 
 칼로리 계산
 MET 값
 약강도 걷기(2.7km/h)/2.3 MET
 중강도 걷기(4.0km/h)/2.9 MET
 고강도 걷기(4.8km/h)/3.3 MET
 조깅(8.0km/h)/6.0 MET
 약강도 러닝(9.7km/h)/8.0 MET
 중강도 러닝(11.3km/h)/10.0 MET
 고강도 러닝(12.9km/h)/11.5 MET
 
 totalcalorie  = MET * weight(kg) * time(hours)
 */
final class ExerciseManager {
    
    @MainActor
    static func calculatedCaloriesBurned(distance: Double, totalTime: Double) -> Double {
        let userInfo = AuthenticationViewModel.shared.userInfo
        let MALE_AVG_HEIGHT = 171
        let MALE_AVG_WEIGHT = 72
        let FEMALE_AVG_HEIGHT = 158
        let FEMALE_AVG_WEIGHT = 57
        let ADULT_AGE = 20
        
        // 유저의 신체정보(미설정시 상단에 정의된 평균값으로 계산)
        let gender = userInfo.gender ?? true // t = male, f = female
        let myHeight = userInfo.height ?? (gender ? MALE_AVG_HEIGHT : FEMALE_AVG_HEIGHT)
        let myWeight = userInfo.weight ?? (gender ? MALE_AVG_WEIGHT : FEMALE_AVG_WEIGHT)
        let myAge = userInfo.age ?? ADULT_AGE
        
        let WALKING_WEAK_INTENSITY = 2.7
        let WALKING_MEDIUM_INTENSITY = 4.0
        let WALKING_HIGH_INTENSITY = 4.8
        let JOGGING_INTENSITY = 8.0
        let RUNNING_WEAK_INTENSITY = 9.7
        let RUNNING_MEDIUM_INTENSITY = 11.3
        let RUNNING_HIGH_INTENSITY = 12.9
        
        let speedPerMinutes = (distance * 1000.0) / (totalTime / 60.0)
        let weightInKilogram = Double(myWeight)
        let timeInHours = (totalTime / 60.0) / 60.0
        
        var MET: Double
        
        switch speedPerMinutes {
        case ..<WALKING_WEAK_INTENSITY:
            MET = 2.3
        case ..<WALKING_MEDIUM_INTENSITY:
            MET = 2.9
        case ..<WALKING_HIGH_INTENSITY:
            MET = 3.3
        case ..<JOGGING_INTENSITY:
            MET = 6.0
        case ..<RUNNING_WEAK_INTENSITY:
            MET = 8.0
        case ..<RUNNING_MEDIUM_INTENSITY:
            MET = 10.0
        case ..<RUNNING_HIGH_INTENSITY:
            MET = 11.5
        default:
            MET = 12.0
        }
        
        let caloriesBurned = MET * weightInKilogram * timeInHours
        
        return caloriesBurned
    }
    
    // 페이스(pace) -> 1km를 가는데 걸리는 시간
    // 5km 이동 30분 소요 = 30/5 = 6min/km
    static func calculatedPace(distance: Double, totalTime: Double) -> Double {
        let distanceInKilometer = distance
        let timeInMinutes = totalTime / 60.0
        
        let pace = timeInMinutes / distance
        
        return pace
    }
    
    // 예상시간 계산
    @MainActor
    static func calculateEstimatedTime(distance: Double, runningStyle: RunningStyle) -> Int {
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


