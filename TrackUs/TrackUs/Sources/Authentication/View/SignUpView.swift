//
//  SignUpView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

enum SignUpFlow {
    case nickname
    case profile
    case physical
    case ageGender
    case runningStyle
    case daily
}

struct SignUpView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: LoginViewModel
    @State private var signUpFlow: SignUpFlow = .nickname
    
    var body: some View {
        VStack(spacing: 30){
            ProgressBar(value: updateProgressValue())
                .frame(height: 12)
            switch signUpFlow {
            case .nickname:
                NickNameView(signUpFlow: $signUpFlow)
            case .profile:
                ProfileImageView(signUpFlow: $signUpFlow)
            case .physical:
                PhysicalView(signUpFlow: $signUpFlow)
            case .ageGender:
                AgeGenderView(signUpFlow: $signUpFlow)
            case .runningStyle:
                RunningStyleView(signUpFlow: $signUpFlow)
            case .daily:
                DailyGoalView(signUpFlow: $signUpFlow)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: signUpFlow)
        .padding([.leading, .trailing], 16)
        .customNavigation {
            Text("회원가입")
        } left: {
            Button(action: {
                backButton()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray1)
            }
        } right: {
            Button(action: {
                skipButton()
                router.popToRoot()
            }) {
                Text(signUpFlow != .nickname ? "건너뛰기" : "")
                    .customFontStyle(.gray1_R12)
            }
        }
    }
    func backButton(){
        switch signUpFlow {
        case .nickname:
            // 테스트용
            viewModel.authenticationState = .unauthenticated
        case .profile:
            signUpFlow = .nickname
        case .physical:
            signUpFlow = .profile
        case .ageGender:
            signUpFlow = .physical
        case .runningStyle:
            signUpFlow = .ageGender
        case .daily:
            signUpFlow = .runningStyle
        }
    }
    
    
    func skipButton(){
        switch signUpFlow {
        case .nickname:
            signUpFlow = .profile
        case .profile:
            signUpFlow = .physical
        case .physical:
            signUpFlow = .ageGender
        case .ageGender:
            signUpFlow = .runningStyle
        case .runningStyle:
            signUpFlow = .daily
        case .daily:
            // 테스트용
            viewModel.authenticationState = .authenticated
        }
    }
    
    // ProgressValue 값 주는 함수
    func updateProgressValue() -> Float{
        switch signUpFlow {
        case .nickname:
            return 1/6
        case .profile:
            return 2/6
        case .physical:
            return 3/6
        case .ageGender:
            return 4/6
        case .runningStyle:
            return 5/6
        case .daily:
            return 6/6
        }
    }
}

struct ProgressBar: View {
    private var value: Float
    
    init(value: Float) {
        self.value = value
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.Gray3)
                
                Capsule().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.main)
                    .animation(.easeInOut(duration: 0.3), value: value)
            }
        }
    }
}

#Preview {
    SignUpView()
}
