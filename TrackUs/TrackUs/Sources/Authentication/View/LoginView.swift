//
//  LoginView.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var router: Router
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @Environment(\.dismiss) var dismiss
    //    let robotoMedium = "Roboto-Medium" // 구글 글꼴
    
    private func signInWithGoogle() {
        Task {
            if await authViewModel.signInWithGoogle() == true {
                dismiss()
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            // 로고
            VStack(spacing: 0) {
                Text("러닝을 즐기고, 사랑하다.")
                    .foregroundStyle(Color.init(hex: 0x575757))
                    .font(.system(size: 16))
                Image(.trackusBigLogo)
                  
                
            }
            
            // 메인 이미지
            Image("LoginImage")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 200, minHeight: 200, maxHeight: 300)
            
            Spacer()
            
            // 텍스트
            
            Text("TrackUs를 통해 러닝 메이트를 모집하고 함께 러닝을 즐겨보세요.")
                .customFontStyle(.gray1_R14)
                .multilineTextAlignment(.center)
                .frame(width: 238)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading) {
                Button(action: {
                    authViewModel.startSignInWithAppleFlow()
                }, label: {
                    HStack(alignment: .center) {
                        // 애플 로고
                        Image(systemName: "applelogo")
                            .resizable()
                            .frame(width: 18, height: 22)
                            .padding(.horizontal, 8)
                        Text("Apple 로 로그인")
                            .font(.system(size: 18))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 56)
                })
                .foregroundStyle(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.87, green: 0.87, blue: 0.87), lineWidth: 1)
                )
                .background(Color.white)
                .cornerRadius(10)
                .padding(.bottom, 12)
                .padding(.horizontal, 36)
                
                Button(action: {
                    // 구글 로그인 기능
                    signInWithGoogle()
                }, label: {
                    HStack(alignment: .center) {
                        // 구글 로고
                        Image("GoogleLogo")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.horizontal, 8)
                        Text("Google 로 로그인")
                            .font(.custom("Roboto-Medium", size: 18))
                        
                    }     .frame(maxWidth: .infinity)
                        .frame(maxHeight: 56)
                })
                .foregroundStyle(.black)
                
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.87, green: 0.87, blue: 0.87), lineWidth: 1)
                )
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 36)
            }
            .padding(.bottom, 24)
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    LoginView()
}
