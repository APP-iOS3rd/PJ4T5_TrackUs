//
//  RunningStyleView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

enum runningStyle {
    case one
    case two
}

struct RunningStyleView: View {
    @Binding private var signUpFlow: SignUpFlow
    
    // nickName 데이터값 변경
    @State private var runningStyle: runningStyle?
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
                    SelectButton(text: "기록갱신", selected: runningStyle == .one){
                        runningStyle = .one
                    }
                    SelectButton(text: "다이어트", selected: runningStyle == .two){
                        runningStyle = .two
                    }
                }
            }
            Spacer()
            
            MainButton(active: runningStyle != nil, buttonText: "다음으로") {
                //userInfoViewModel.userInfo.
                signUpFlow = .daily
            }
        }
    }
}
