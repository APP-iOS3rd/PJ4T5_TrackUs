//
//  DailyGoalView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

struct DailyGoalView: View {
    @EnvironmentObject var router: Router
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @Binding private var signUpFlow: SignUpFlow
    
    // nickName 데이터값 변경
    @State private var goal : Double?
    @State private var goalPicker: Bool = false
    @State private var isProfilePublic: Bool = true
    
    init(signUpFlow: Binding<SignUpFlow>) {
        self._signUpFlow = signUpFlow
    }
    
    var body: some View {
        VStack(spacing: 40){
            Description(title: "일일 운동량", detail: "하루에 정해진 운동량을 설정하고 꾸준히 뛸 수 있는 이유를 만들어 주세요.")
            SelectPicker(selectedValue: $goal, pickerType: .dailyGoal)
            
            Spacer()
            VStack{
                Button {
                    isProfilePublic.toggle()
                } label: {
                    HStack(spacing: 8){
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(.main.opacity(isProfilePublic ? 1 : 0))
                            .padding(4)
                            .overlay(
                                Circle()
                                    .stroke(.gray3, lineWidth: 1)
                            )
                        Text("내 프로필 공개")
                            .customFontStyle(.gray1_R12)
                    }
                    .animation(.easeIn(duration: 0.3), value: isProfilePublic)
                }
                MainButton(active: goal != nil, buttonText: "다음으로") {
                    authViewModel.userInfo.setDailyGoal = goal
                    authViewModel.userInfo.isProfilePublic = isProfilePublic
                    Task{
                        authViewModel.storeUserInfoInFirebase()
                    }
                    authViewModel.authenticationState = .authenticated
                    router.popToRoot()
                }
            }
        }
    }
}
