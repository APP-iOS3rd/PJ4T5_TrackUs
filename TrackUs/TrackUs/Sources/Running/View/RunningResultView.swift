//
//  RunningResultView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct RunningResultView: View {
    @EnvironmentObject var router: Router
    @State private var showingPopup = false
    let settingViewModel = SettingPopupViewModel()
    @ObservedObject var trackingViewModel: TrackingViewModel
    
    // 목표거리
    var targetDistance: Double {
        trackingViewModel.isGroup ? trackingViewModel.goalDistance : settingViewModel.goalMinValue
    }
    
    // 목표 칼로리
    var targetCalorie: Double {
        return ExerciseManager.calculatedCaloriesBurned(distance: targetDistance)
    }
    
    // 예상시간
    var estimatedTime: Int {
        return ExerciseManager.calculateEstimatedTime(distance: targetDistance * 60)
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
            return "\(distanceDifference.asString(unit: .kilometer)) 더 뛰었습니다!"
        } else {
            return "\(distanceDifference.asString(unit: .kilometer)) 덜 뛰었습니다."
        }
    }
    
    // 칼로리 비교
    var compareCaloriesLabel: String {
        let isGoalReached = trackingViewModel.calorie >= targetCalorie
        let caloriesDifference = abs(trackingViewModel.distance - targetCalorie)
        
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
}

extension RunningResultView {
    
    var body: some View {
        VStack {
            PathPreviewMap(coordinates: trackingViewModel.coordinates)
            
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
                        Text("")
                            .customFontStyle(.gray1_R14)
                            .lineLimit(3)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    
                    
                    HStack(spacing: 28) {
                        MainButton(active: true, buttonText: "홈으로 가기", buttonColor: .gray1, minHeight: 45) {
                            router.popToRoot()
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
        .popup(isPresented: $showingPopup) {
            SaveDataPopup(showingPopup: $showingPopup, title: $trackingViewModel.title) {
                trackingViewModel.uploadRecordedData(targetDistance: settingViewModel.goalMinValue, expectedTime: Double(settingViewModel.estimatedTime))
                self.hideKeyboard()
                self.showingPopup = false
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
        .loadingWithNetwork(status: trackingViewModel.newtworkStatus)
        .preventGesture()
        .onChange(of: trackingViewModel.newtworkStatus) { status in
            print(status)
            if status == .success {
                router.popToRoot()
            }
        }
    }
}





