//
//  RunningStyleView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI


struct RunningStyleView: View {
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @Binding private var signUpFlow: SignUpFlow
    
    // nickName 데이터값 변경
    @State private var runningStyle: RunningStyle?
    @State private var availability: Bool = false
    
    init(signUpFlow: Binding<SignUpFlow>) {
        self._signUpFlow = signUpFlow
    }
    
    var body: some View {
        VStack(spacing: 40){
            Description(title: "러닝 스타일", detail: "추구하는 러닝 스타일을 설정하고 그에 맞는 피드백을 받아보세요.")
            
            VStack(alignment: .leading, spacing: 20){
                Text("러닝 스타일")
                    .customFontStyle(.gray1_R16)
                HStack(spacing: 15){
                    SelectButton(text: "걷기", selected: runningStyle == .walking){
                        runningStyle = .walking
                    }
                    SelectButton(text: "조깅", selected: runningStyle == .jogging){
                        runningStyle = .jogging
                    }
                }
                HStack(spacing: 15){
                    SelectButton(text: "달리기", selected: runningStyle == .running){
                        runningStyle = .running
                    }
                    SelectButton(text: "인터벌", selected: runningStyle == .interval){
                        runningStyle = .interval
                    }
                }
            }
            Spacer()
            
            MainButton(active: runningStyle != nil, buttonText: "다음으로") {
                authViewModel.userInfo.runningStyle = runningStyle
                signUpFlow = .daily
            }
        }
    }
}
