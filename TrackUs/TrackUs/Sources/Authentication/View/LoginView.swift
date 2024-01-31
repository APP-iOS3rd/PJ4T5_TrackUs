//
//  LoginView.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
                // 타이틀 이미지
                Image("LoginImage")
                    .resizable()
                    .scaledToFill()
            
            VStack {
                VStack (alignment: .leading){
                    // 트랙어스 로고
                    HStack {
                        Image("TrackUsLogo")
                            .resizable()
                            .frame(width: 91, height: 26.39)
                        
                        Spacer()
                    }
                    VStack (alignment: .leading){
                        Text("러닝을 즐기고,")
                        Text("사랑하다.")
                    }
                    .font(.system(size: 30,weight: .bold))
//                    .foregroundColor(.Gray1)
                    .foregroundColor(Color(red: 0.34, green: 0.34, blue: 0.34))
                    .padding(.bottom, 5)
                    
                    Text("TrackUs를 통해 러닝 메이트를 모집하고 함께 러닝을 즐겨보세요.")
                        .font(.system(size: 11))
                        .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.54))
//                        .foregroundColor(.Gray2)
                }
                .padding(.horizontal, 20)
                
                Spacer() // 그림
                
                VStack {
                    Button(action: {
                        // 애플 로그인 기능
                        
                    }, label: {
                        HStack {
                            // 애플 로고
                            Image(systemName: "applelogo")
                            Text("Apple 계정으로 시작하기")
                        }
                        
                    })
                    .foregroundStyle(.black)
                    .frame(width: 350, height: 56)
                    .padding(.horizontal, -16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.87, green: 0.87, blue: 0.87), lineWidth: 1)
                    )
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom, 12)
                    
                    Button(action: {
                        // 구글 로그인 기능
                        
                    }, label: {
                        HStack {
                            // 구글 로고
                            Image("GoogleLogo")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Google 계정으로 시작하기")
                        }
                    })
                    .foregroundStyle(.black)
                    .frame(width: 350, height: 56)
                    .padding(.horizontal, -16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.87, green: 0.87, blue: 0.87), lineWidth: 1)
                    )
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding(.bottom, 24)
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    LoginView()
}
