//
//  RunningResultView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct RunningResultView: View {
    private let settingViewModel = SettingPopupViewModel()
    
    @EnvironmentObject var router: Router
    @ObservedObject var trackingViewModel: TrackingViewModel
    
    @State private var showingPopup = false
    @State private var showingAlert = false
    
    
    // 목표거리
    var targetDistance: Double {
        trackingViewModel.isGroup ? trackingViewModel.goalDistance : settingViewModel.goalMinValue
    }
    
    // 목표 칼로리
    var targetCalorie: Double {
        return ExerciseManager.calculatedCaloriesBurned(distance: targetDistance)
    }
    
    // 예상시간
    var estimatedTime: Double {
        return ExerciseManager.calculateEstimatedTime(distance: targetDistance)
    }
    
    // 킬로미터 비교 -> 실제 뛴 거리 / 예상 거리
    var compareKilometers: String {
        return "\(trackingViewModel.distance.asString(unit: .kilometer)) / \(targetDistance.asString(unit: .kilometer))"
    }
    
    // 소모 칼로리 비교 -> 실제 소모 칼로리 / 예상 소모 칼로리
    var compareCalories: String {
        return "\(trackingViewModel.calorie.asString(unit: .calorie)) / \(targetCalorie.asString(unit: .calorie))"
    }
    
    // 소요시간 비교 -> 소요시간 / 예상 소요시간
    var compareEstimatedTime: String {
        return "\(trackingViewModel.elapsedTime.asString(style: .positional)) / \(Double(estimatedTime).asString(style: .positional))"
    }
    
    // 킬로미터 비교
    var compareKilometersLabel: String {
        let isGoalReached = trackingViewModel.distance >= targetDistance
        let distanceDifference = abs(trackingViewModel.distance - targetDistance)
        
        if isGoalReached {
            return "\(distanceDifference.asString(unit: .kilometer)) 만큼 더 뛰었습니다!"
        } else {
            return "\(distanceDifference.asString(unit: .kilometer)) 적게 뛰었어요."
        }
    }
    
    // 칼로리 비교
    var compareCaloriesLabel: String {
        let isGoalReached = trackingViewModel.calorie >= targetCalorie
        let caloriesBurned = ExerciseManager.calculatedCaloriesBurned(distance: trackingViewModel.distance)
        let caloriesDifference = abs(caloriesBurned - targetCalorie)
        
        if isGoalReached {
            return "\(caloriesDifference.asString(unit: .calorie)) 더 소모했어요!"
        } else {
            return "\(caloriesDifference.asString(unit: .calorie)) 덜 소모했어요."
        }
    }
    
    // 소요시간 비교
    var compareEstimatedTimeLabel: String {
        let isGoalReached = trackingViewModel.elapsedTime < Double(estimatedTime)
        let estimatedTimeDifference = abs(trackingViewModel.elapsedTime - Double(estimatedTime))
        if isGoalReached {
            return "\(estimatedTimeDifference.asString(style: .positional)) 만큼 단축되었어요!"
        } else {
            return "\(estimatedTimeDifference.asString(style: .positional)) 만큼 더 소요됬어요."
        }
    }
    
    var feedbackMessageLabel: String {
        let isGoalDistanceReached = trackingViewModel.distance >= targetDistance
        let isTimeReduction = trackingViewModel.elapsedTime < Double(estimatedTime)
        
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

extension RunningResultView {
    
    var body: some View {
        VStack {
            PathPreviewMap(
                coordinates: trackingViewModel.coordinates
            )
            
            VStack {
                VStack(spacing: 20) {
                    
                    RoundedRectangle(cornerRadius: 27)
                        .fill(.indicator)
                        .frame(
                            width: 32,
                            height: 4
                        )
                    
                    Text("러닝 결과")
                        .customFontStyle(.gray1_SB20)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("운동량")
                            .customFontStyle(.gray1_R16)
                        
                        HStack {
                            Image(.distance)
                            VStack(alignment: .leading) {
                                Text("킬로미터")
                                Text(compareKilometers)
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text(compareKilometersLabel)
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.fire)
                            VStack(alignment: .leading) {
                                Text("소모 칼로리")
                                Text(compareCalories)
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text(compareCaloriesLabel)
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.time)
                            VStack(alignment: .leading) {
                                Text("러닝 타임")
                                Text(compareEstimatedTime)
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text(compareEstimatedTimeLabel)
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.pace)
                            VStack(alignment: .leading) {
                                Text("페이스")
                                Text(trackingViewModel.pace.asString(unit: .pace))
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text("-")
                                .customFontStyle(.gray1_R12)
                        }
                    }
                    
                    HStack {
                        Text(feedbackMessageLabel)
                            .customFontStyle(.gray1_R14)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                        
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    
                    
                    HStack(spacing: 28) {
                        MainButton(active: true, buttonText: "홈으로 가기", buttonColor: .gray1, minHeight: 45) {
                            showingAlert = true
                        }
                        
                        MainButton(active: true, buttonText: "러닝 기록 저장", buttonColor: .main, minHeight: 45) {
                            showingPopup = true
                        }
                        
                    }
                }
                .padding(20)
            }
            .zIndex(2)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(
                .rect (
                    topLeadingRadius: 12,
                    topTrailingRadius: 12
                )
            )
            .offset(y: -10)
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("홈으로 이동"),
                message: Text("홈으로 이동 하시겠습니까? 홈으로 이동하면 러닝 데이터가 리포트에 반영되지 않습니다."),
                primaryButton: .default (
                    Text("취소"),
                    action: { }
                ),
                secondaryButton: .destructive (
                    Text("이동"),
                    action: {
                        router.popToRoot()
                    }
                )
            )
        }
        .popup(isPresented: $showingPopup) {
            SaveDataPopup(showingPopup: $showingPopup, title: $trackingViewModel.title) {
                do {
                   try trackingViewModel.uploadRunningData(targetDistance: settingViewModel.goalMinValue, expectedTime: Double(settingViewModel.estimatedTime))
                    self.hideKeyboard()
                    self.showingPopup = false
                } catch let error {
                    trackingViewModel.isLoading = false
                }
            }
        } customize: {
            $0
                .backgroundColor(.black.opacity(0.3))
                .isOpaque(false)
                .dragToDismiss(false)
                .closeOnTap(false)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        .ignoresSafeArea(.keyboard)
        .onChange(of: trackingViewModel.isLoading) { isLoading in
            !isLoading ? router.popToRoot() : nil
        }
        .presentLoadingView(status: trackingViewModel.isLoading)
        .preventGesture()
    }
}





