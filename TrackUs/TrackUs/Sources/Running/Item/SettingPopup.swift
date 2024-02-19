//
//  SettingPopup.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct SettingPopup: View {
    @Binding var showingPopup: Bool
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
                    Image("BigFire")
                    
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
                            get: { settingVM.goalMinValue },
                            set: { newValue in
                                settingVM.goalMinValue = newValue
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
                        
                        Picker(selection: $settingVM.estimatedTime) {
                            ForEach(1..<240, id: \.self) {
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
                
                Button(action: {
                    settingVM.saveSettings()
                    showingPopup = false
                }) {
                    Text("설정 완료")
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
}

#Preview {
    SettingPopup(showingPopup: .constant(true), settingVM: SettingPopupViewModel())
}
