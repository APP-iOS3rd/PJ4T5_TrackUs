//
//  RunningResultView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct RunningResultView: View {
    @EnvironmentObject var router: Router
    
    @ObservedObject var trackingViewModel: TrackingViewModel
    @ObservedObject private var settingViewModel = SettingPopupViewModel()
    private let exerciseManager: ExerciseManager!
    
    @State private var showingPopup = false
    @State private var showingAlert = false
    
    init(trackingViewModel: TrackingViewModel, settingViewModel: SettingPopupViewModel = SettingPopupViewModel(), showingPopup: Bool = false, showingAlert: Bool = false) {
        
        self.trackingViewModel = trackingViewModel
        self.settingViewModel = settingViewModel
        self.showingPopup = showingPopup
        self.showingAlert = showingAlert
        self.exerciseManager = ExerciseManager(
            distance: trackingViewModel.distance,
            target: trackingViewModel.goalDistance,
            elapsedTime: trackingViewModel.elapsedTime
        )
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
                                Text(exerciseManager.compareKilometers)
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text(exerciseManager.compareKilometersLabel)
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.fire)
                            VStack(alignment: .leading) {
                                Text("소모 칼로리")
                                Text(exerciseManager.compareCalories)
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text(exerciseManager.compareCaloriesLabel)
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.time)
                            VStack(alignment: .leading) {
                                Text("러닝 타임")
                                Text(exerciseManager.compareEstimatedTime)
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text(exerciseManager.compareEstimatedTimeLabel)
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
                        Text(exerciseManager.feedbackMessageLabel)
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
//                do {
//                   try trackingViewModel.uploadRunningData(targetDistance: settingViewModel.goalMinValue, expectedTime: Double(settingViewModel.estimatedTime))
//                    self.hideKeyboard()
//                    self.showingPopup = false
//                } catch let error {
//                    trackingViewModel.isLoading = false
//                }
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





