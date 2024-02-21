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
    
    // TODO: - 여러곳에서 사용할 수 있도록 로직분리
    var estimatedCalories: Double {
        return ExerciseManager.calculatedCaloriesBurned(distance: settingViewModel.goalMinValue, totalTime: Double(settingViewModel.estimatedTime) * 60)
    }
    
    var estimatedTimeText: String {
        return  Double(settingViewModel.estimatedTime * 60).asString(style: .positional)
    }
    
    // 하단 운동결과 피드백 메세지
    var feedbackMessageLabel: String {
        let estimatedTime = Double(settingViewModel.estimatedTime) // 예상시간
        let distanceInKilometers = trackingViewModel.distance // 킬로미터
        let goalDistance = Double(settingViewModel.goalMinValue) // 목표치
        let goalReached = distanceInKilometers >= goalDistance // 목표도달 여부
        let timeReduction = trackingViewModel.elapsedTime < estimatedTime // 시간단축 여부
        
        if goalReached, timeReduction {
            return "대단해요! 목표를 달성하고 도전 시간을 단축했어요. 지속적인 노력이 효과를 나타내고 있습니다. 계속해서 도전해보세요!"
        }
        else if !goalReached, timeReduction {
            return "목표에는 도달하지 못했지만, 러닝 시간을 단축했어요! 훌륭한 노력입니다. 계속해서 노력하면 목표에 더 가까워질 거에요!"
        }
        else if goalReached, !timeReduction {
            return "목표에 도달했어요! 비록 러닝 시간을 단축하지 못했지만, 목표를 이루다니 정말 멋져요. 지속적인 노력으로 시간을 줄여가는 모습을 기대해봅니다!"
        } else {
            return "목표에 도달하지 못했어도 괜찮아요. 중요한 건 노력한 자체입니다. 목표와 거리를 조금 낮춰서 차근차근 도전해보세요!"
        }
    }
    
    // 목표값과 비교하여 수치로 알려줌
    var elapsedTimeDifferenceLabel: String {
        let differenceInSeconds = Double(settingViewModel.estimatedTime * 60) - trackingViewModel.elapsedTime
        if differenceInSeconds > 0  {
            return "예상 시간보다 \(differenceInSeconds.asString(style: .positional)) 빨리 끝났어요!"
        } else {
            return "예상 시간보다 \(abs(differenceInSeconds).asString(style: .positional)) 늦게 끝났어요"
        }
    }
    
    var kilometerDifferenceLabel: String {
        let difference = (trackingViewModel.distance) - settingViewModel.goalMinValue
        if difference > 0 {
            return "목표보다 \(difference.asString(unit: .kilometer)) 더 뛰었어요!"
        } else {
            return "목표보다 \(abs(difference).asString(unit: .kilometer)) 덜 뛰었어요."
        }
    }
    
    var calorieDifferenceLabel: String {
        let difference = (trackingViewModel.calorie) - estimatedCalories
        if difference > 0 {
            return "\(difference.asString(unit: .calorie))를 더 소모했어요!"
        } else {
            return "\(abs(difference).asString(unit: .calorie))를 덜 소모했어요."
        }
    }
    
    // 실제기록/예상목표
    var kilometerComparisonLabel: String {
        "\(trackingViewModel.distance.asString(unit: .kilometer)) / \(settingViewModel.goalMinValue.asString(unit: .kilometer))"
    }
    
    var calorieComparisonLabel: String {
        "\(trackingViewModel.calorie.asString(unit: .calorie)) / \(estimatedCalories.asString(unit: .calorie))"
    }
    
    var timeComparisonLabel: String {
        "\(trackingViewModel.elapsedTime.asString(style: .positional)) / \(Double(settingViewModel.estimatedTime * 60).asString(style: .positional))"
    }
}

extension RunningResultView {
    
    var body: some View {
        VStack {
            RouteMapView(lineCoordinates: trackingViewModel.coordinates)
            
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
                            Image(.shose)
                            VStack(alignment: .leading) {
                                Text("킬로미터")
                                Text(kilometerComparisonLabel)
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text(kilometerDifferenceLabel)
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.fire)
                            VStack(alignment: .leading) {
                                Text("소모 칼로리")
                                Text(calorieComparisonLabel)
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text(calorieDifferenceLabel)
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.time)
                            VStack(alignment: .leading) {
                                Text("러닝 타임")
                                Text(timeComparisonLabel)
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text(elapsedTimeDifferenceLabel)
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
        .onChange(of: trackingViewModel.newtworkStatus) { newValue in
            if newValue == .success {
                router.popToRoot()
            }
        }
    }
}


       


