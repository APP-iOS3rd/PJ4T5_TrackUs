//
//  NickNameView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

struct NickNameView: View {
    @Binding private var signUpFlow: SignUpFlow
    @StateObject var authViewModel = AuthenticationViewModel.shared
    
    // nickName 데이터값 변경
    @State private var nickName: String = ""
    @State private var availability: Bool = true
    
    init(signUpFlow: Binding<SignUpFlow>) {
        self._signUpFlow = signUpFlow
    }
    
    var body: some View {
        VStack(spacing: 0){
            Description(title: "닉네임 설정", detail: "다른 러너들에게 자신을 잘 나타낼 수 있는 닉네임을 설정해주세요.")
                .padding(.bottom, 40)
            VStack(alignment: .leading, spacing: 7){
                Text("닉네임")
                    .customFontStyle(.gray1_M16)
                NickNameTextFiled(text: $nickName, availability: $availability)
            }
            
            Spacer()
            MainButton(active: availability, buttonText: "다음으로") {
                signUpFlow = .profile
                authViewModel.userInfo.username = nickName
            }
        }
    }
    
}
//
//#Preview {
//    NickNameView()
//}
