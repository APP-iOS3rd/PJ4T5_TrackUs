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
struct ExerciseManager {
    let distance: Double
    let target: Double
    let elapsedTime: Double
    
    /// 이동거리 / 목표
    @MainActor
    var compareKilometers: String {
        "\(distance.asString(unit: .kilometer)) / \(target.asString(unit: .kilometer))"
    }
    
    /// 칼로리 / 예상
    @MainActor
    var compareCalories: String {
        "\(Self.calculatedCaloriesBurned(distance: distance).asString(unit: .calorie)) / \(Self.calculatedCaloriesBurned(distance: target).asString(unit: .calorie))"
    }
    
    /// 시간 / 예상
    @MainActor
    var compareEstimatedTime: String {
        "\(elapsedTime.asString(style: .positional)) / \(Self.calculateEstimatedTime(distance: self.target).asString(style: .positional))"
    }
    
    /// 이동거리(km) 비교 텍스트
    @MainActor
    var compareKilometersLabel: String {
        let isGoalReached = distance >= target
        let distanceDifference = abs(distance - target)
        
        if isGoalReached, distanceDifference < 1 {
            return "목표하신 \(target.asString(unit: .kilometer)) 러닝을 완료했어요 🎉"
        } else if isGoalReached {
            return "\(distanceDifference.asString(unit: .kilometer)) 만큼 더 뛰었습니다!"
        }
        else {
            return "\(distanceDifference.asString(unit: .kilometer)) 적게 뛰었어요."
        }
    }
    
    /// 칼로리 비교 텍스트
    @MainActor
    var compareCaloriesLabel: String {
        let calorieConsumed = Self.calculatedCaloriesBurned(distance: distance)
        let calorieExpected = Self.calculatedCaloriesBurned(distance: target)
        let isGoalReached = calorieConsumed >= calorieExpected
        let caloriesDiffernce = abs(calorieConsumed - calorieExpected)
        
        if isGoalReached, caloriesDiffernce == 0 {
            return "목표치인 \(calorieConsumed.asString(unit: .calorie)) 만큼 소모했어요 🔥"
        }
        else if isGoalReached {
            return "\(caloriesDiffernce.asString(unit: .calorie)) 더 소모했어요!"
        } else {
            return "\(caloriesDiffernce.asString(unit: .calorie)) 덜 소모했어요!"
        }
    }
    
    /// 소요시간 비교 텍스트
    @MainActor
    var compareEstimatedTimeLabel: String {
        let estimatedTime = Self.calculateEstimatedTime(distance: target)
        let isGoalReached = elapsedTime <= estimatedTime
        let timeDifference = abs(estimatedTime - elapsedTime)
        
        if isGoalReached, timeDifference < 1 {
            return "목표하신 시간내에 러닝을 완료했어요! 🎉"
        }
        else if isGoalReached {
            return "\(timeDifference.asString(style: .positional)) 만큼 단축되었어요!"
        } else {
            return "\(timeDifference.asString(style: .positional)) 만큼 더 소요되었어요."
        }
    }
    
    /// 피드백 메세지
    @MainActor
    var feedbackMessageLabel: String {
        let isGoalDistanceReached = distance > target
        let estimatedTime = Self.calculateEstimatedTime(distance: target)
        let isTimeReduction = elapsedTime < estimatedTime
        
        if isGoalDistanceReached, isTimeReduction {
            return "대단해요! 목표를 달성하고 도전 시간을 단축했어요. 지속적인 노력이 효과를 나타내고 있습니다. 계속해서 도전해보세요!"
        } else if !isGoalDistanceReached, isTimeReduction {
            return "목표에는 도달하지 못했지만, 러닝 시간을 단축했어요! 훌륭한 노력입니다. 계속해서 노력하면 목표에 더 가까워질 거에요!"
        } else if isGoalDistanceReached, !isTimeReduction {
            return "목표에 도달했어요! 비록 러닝 시간을 단축하지 못했지만, 목표를 이루다니 정말 멋져요. 지속적인 노력으로 시간을 줄여가는 모습을 기대해봅니다!"
        } else {
            return "목표에 도달하지 못했어도 괜찮아요. 중요한 건 노력한 자체입니다. 목표와 거리를 조금 낮춰서 차근차근 도전해보세요!"
        }
    }
}

// MARK: - 운동량 계산
extension ExerciseManager {
    
    @MainActor
    static var myRunningStyle: RunningStyle {
        AuthenticationViewModel.shared.userInfo.runningStyle ?? .jogging
    }
    
    /// 거리(m) + 러닝스타일 -> 예상시간(sec)
    /// 거리(m)  * m당 평균 소요시간(러닝스타일)
    @MainActor
    static func calculateEstimatedTime(distance: Double, style: RunningStyle? = nil) -> Double {
        let runningStyle = style ?? myRunningStyle
        
        switch runningStyle {
        case .walking:
            return floor(distance * 0.9)
        case .jogging:
            return floor(distance * 0.45)
        case .running:
            return floor(distance * 0.3)
        case .interval:
            return floor(distance * 0.15)
        }
    }
    
    /// 거리(m) * 체중(kg) * 칼로리소모(m) -> 칼로리
    @MainActor
    static func calculatedCaloriesBurned(distance: Double) -> Double {
        var caloriesPerMeters: Double
        
        switch myRunningStyle {
        case .walking:
            caloriesPerMeters = 0.041 // 보행에 따른 칼로리 소모량
        case .jogging:
            caloriesPerMeters = 0.063 // 조깅에 따른 칼로리 소모량
        case .running:
            caloriesPerMeters = 0.080 // 러닝에 따른 칼로리 소모량
        case .interval:
            caloriesPerMeters = 0.1 // 스프린트에 따른 칼로리 소모량
        }
        
        let caloriesBurned = distance * caloriesPerMeters
        
        return caloriesBurned
    }
    
    /// 시간(sec) -> 러닝 페이스
    static func calculatedPace(distance: Double, timeInSeconds: Double) -> Double {
        let timeInMinutes = timeInSeconds / 60.0
        let pace = timeInMinutes / (distance / 1000.0)
        
        return pace
    }
}

