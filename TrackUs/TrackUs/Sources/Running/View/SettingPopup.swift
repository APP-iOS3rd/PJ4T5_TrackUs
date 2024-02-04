//
//  SettingPopup.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct SettingPopup: View {
    @Binding var showingPopup: Bool
    @State private var goalMinValue: Double = 0.1
    @State private var goalMaxValue: Double = 40.0
    @State private var estimatedTime = 0
    
    var body: some View {
        VStack {
            VStack(spacing: 30) {
                // 팝업닫기
                HStack {
                    Spacer()
                    Button(action: {
                        showingPopup = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(.gray1)
                    }
                }
                
                // 설명글
                VStack {
                    Image("BigFire")
                    
                    Text("오늘은 얼마나 달리실건가요?")
                        .customFontStyle(.gray1_B16)
                    
                    Text("러닝 시작 전, 러닝 목표를 설정해보세요!")
                        .customFontStyle(.gray1_R16)
                }
                
                // 목표 거리, 러닝시간 설정
                VStack(spacing: 20) {
                    VStack {
                        Text("목표 거리량")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.gray1)
                        
                        Picker(selection: $goalMinValue) {
                            ForEach(Array(stride(from: goalMinValue, through: goalMaxValue, by: 0.1)), id: \.self) {
                                Text("\($0, specifier: "%.1f") km")
                                    .customFontStyle(.gray1_R16)
                            }
                        } label: {}
                            .accentColor(.gray1)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.divider, lineWidth: 1)
                            )
                    }
                    
                    // 러닝 시간
                    VStack {
                        Text("러닝 시간")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.gray1)
                        
                        Picker(selection: $estimatedTime) {
                            ForEach(1..<240, id: \.self) {
                                Text("\($0) min")
                                    .customFontStyle(.gray1_R16)
                            }
                        } label: {}
                            .accentColor(.gray1)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.divider, lineWidth: 1)
                            )
                    }
                }
                
                // 설정 완료
                Button(action: {
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
    SettingPopup(showingPopup: .constant(true))
}
