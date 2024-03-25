//
//  SettingPopup.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct SettingPopup: View {
    @Binding var showingPopup: Bool
    @EnvironmentObject var router: Router
    //    @StateObject var trackingViewModel = TrackingViewModel(go)
    @ObservedObject var settingVM: SettingPopupViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    Button(action: {
                        showingPopup = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(.gray1)
                    }
                }
                
                VStack {
                    Image(.dart)
                    
                    Text("오늘은 얼마나 달리실건가요?")
                        .customFontStyle(.gray1_B16)
                    
                    Text("러닝 시작 전, 러닝 목표를 설정해보세요!")
                        .customFontStyle(.gray1_R16)
                }
                
                VStack(spacing: 20) {
                    VStack {
                        Text("목표 거리량")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.gray1)
                        
                        Picker(selection: Binding<Double>(
                            get: { settingVM.goalMinValue / 1000.0 },
                            set: { newValue in
                                settingVM.goalMinValue = newValue * 1000.0
                                settingVM.updateEstimatedTime()
                            }
                        )) {
                            ForEach(Array(stride(from: 0.1, through: 40.0, by: 0.1)), id: \.self) {
                                Text("\($0, specifier: "%.1f") km")
                                    .customFontStyle(.gray1_R16)
                            }
                        } label: {}
                            .padding(5)
                            .accentColor(.gray1)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.divider, lineWidth: 1)
                            )
                    }
                    
                    VStack {
                        Text("러닝 시간")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.gray1)
                        
                        Picker(selection: Binding<Int>(
                            get: { Int(settingVM.estimatedTime / 60.0) },
                            set: { newValue in
                                settingVM.estimatedTime = Double(newValue) * 60.0
                            }
                        ))  {
                            ForEach(1..<240, id: \.self)  {
                                Text("\($0) min")
                                    .customFontStyle(.gray1_R16)
                            }
                        } label: {}
                            .padding(5)
                            .accentColor(.gray1)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.divider, lineWidth: 1)
                            )
                    }
                }
                
                Button(action: startButtonTapped) {
                    Text("개인 러닝 시작")
                        .customFontStyle(.white_B16)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                }
                .background(.main)
                .clipShape(Capsule())
                .padding(.bottom, 12)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(12)
        .padding(.horizontal, 30)
    }
    
    func startButtonTapped() {
        showingPopup = false
        settingVM.saveSettings()
        router.push(.runningStart(
            TrackingViewModel(goalDistance: settingVM.goalMinValue)
        ))
    }
}