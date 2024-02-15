//
//  RunningResultView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct RunningResultView: View {
    @EnvironmentObject var router: Router
    @StateObject var mapViewModel = MapViewModel()
    let runningRecord: RunningRecord
    let settingViewModel = SettingPopupViewModel()
    
    var feedbackMessage: String {
        let estimatedTimeDouble = Double(settingViewModel.estimatedTime)
        let distanceInKilometers = runningRecord.distance / 1000.0
        let goalMinValue = Double(settingViewModel.goalMinValue)

        if distanceInKilometers > goalMinValue {
            if runningRecord.elapsedTime < estimatedTimeDouble {
                return "예상 시간보다 빠르게 도착했어요!"
            } else {
                return "예상 시간보다 느리게 도착했어요!"
            }
        } else {
            return "목표 미도달"
        }
    }
    
    var estimatedCalories: Double {
        let weightFactor = Double(mapViewModel.authViewModel.userInfo.weight ?? 70) * 0.035
        let estimatedTime = Double(settingViewModel.estimatedTime)
        let goalMinValue = Double(settingViewModel.goalMinValue)
        return weightFactor + estimatedTime + goalMinValue
    }
    
    var estimatedTimeText: String {
        let totalSeconds = settingViewModel.estimatedTime * 60
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var elapsedTimeDifferenceText: String {
        let differenceInSeconds = Double(settingViewModel.estimatedTime * 60) - runningRecord.elapsedTime
        let absoluteDifference = abs(differenceInSeconds)
        let minutes = Int(absoluteDifference) / 60
        let seconds = Int(absoluteDifference) % 60
        let sign = differenceInSeconds < 0 ? "늦게" : "빨리"
        return "예상 시간보다 \(String(format: "%02d:%02d", minutes, seconds)) \(sign) 끝났어요!"
    }
    
    var body: some View {
        VStack {
            RouteMapView(lineCoordinates: runningRecord.coordinates)
            
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
                                Text(String(format: "%.2f", runningRecord.distance / 1000.0) + " km / \(settingViewModel.goalMinValue) km")
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            let difference = (runningRecord.distance / 1000.0) - settingViewModel.goalMinValue
                            if difference > 0 {
                                Text("목표보다 \(String(format: "%.2f", difference)) km 더 뛰었어요!")
                                    .customFontStyle(.gray1_R12)
                            } else {
                                Text("목표보다 \(String(format: "%.2f", abs(difference))) km 덜 뛰었어요")
                                    .customFontStyle(.gray1_R12)
                            }
                        }
                        
                        HStack {
                            Image(.fire)
                            VStack(alignment: .leading) {
                                Text("소모 칼로리")
                                Text(String(format: "%.1f", runningRecord.calorie) + " kcal / \(estimatedCalories) kcal ")
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            let difference = runningRecord.calorie - estimatedCalories
                            if difference > 0 {
                                Text("\(String(format: "%.1f", (difference)))kcal를 더 소모했어요!")
                                    .customFontStyle(.gray1_R12)
                            } else {
                                Text("\(String(format: "%.1f", abs(difference)))kcal를 덜 소모했어요!")
                                    .customFontStyle(.gray1_R12)
                            }
                        }
                        
                        HStack {
                            Image(.time)
                            VStack(alignment: .leading) {
                                Text("러닝 타임")
                                Text("\(runningRecord.elapsedTime.asString(style: .positional)) / \(estimatedTimeText)")
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text(elapsedTimeDifferenceText)
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.pace)
                            VStack(alignment: .leading) {
                                Text("페이스")
                                Text(runningRecord.paceMinutes == 0 && runningRecord.paceSeconds == 0 ? "-'--''" : String(format: "%2d'%02d''", runningRecord.paceMinutes, runningRecord.paceSeconds))
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text("-")
                                .customFontStyle(.gray1_R12)
                        }
                    }
                    
                    HStack {
                        Text(feedbackMessage)
                            .customFontStyle(.gray1_R14)
                        Spacer()
                    }
                    
                    
                    MainButton(buttonText: "리포트로 이동하기", action: {router.popToRoot()})
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
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        .preventGesture()
    }
}

//#Preview {
//    RunningResultView()
//}
