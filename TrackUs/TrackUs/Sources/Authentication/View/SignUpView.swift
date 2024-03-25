//
//  SignUpView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

enum SignUpFlow {
    case terms
    case nickname
    case profile
    case physical
    case ageGender
    case runningStyle
    case daily
}

struct SignUpView: View {
    @EnvironmentObject var router: Router
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @State private var signUpFlow: SignUpFlow = .terms
    
    var body: some View {
        VStack(spacing: 30){
            ProgressBar(value: updateProgressValue())
                .frame(height: 12)
            switch signUpFlow {
            case .terms:
                TermsOfServiceView(signUpFlow: $signUpFlow)
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
                if signUpFlow != .terms{
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray1)
                }
            }
        } right: {
            Button(action: {
                skipButton()
            }) {
                if signUpFlow != .terms && signUpFlow != .nickname{
//                    Text(signUpFlow != .nickname ? "건너뛰기" : "")
                    Text("건너뛰기")
                        .customFontStyle(.gray1_R12)
                }
            }
        }
    }
    func backButton(){
        switch signUpFlow {
        case .terms:
            authViewModel.authenticationState = .unauthenticated
        case .nickname:
            signUpFlow = .terms
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
//        case .nickname:
//            signUpFlow = .profile
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
            router.popToRoot()
            Task{
                authViewModel.storeUserInfoInFirebase()
            }
            authViewModel.authenticationState = .authenticated
        default:
            return
        }
    }
    
    // ProgressValue 값 주는 함수
    func updateProgressValue() -> Float{
        switch signUpFlow {
        case .terms:
            return 1/7
        case .nickname:
            return 2/7
        case .profile:
            return 3/7
        case .physical:
            return 4/7
        case .ageGender:
            return 5/7
        case .runningStyle:
            return 6/7
        case .daily:
            return 1
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
//
#Preview {
    SignUpView()
}
