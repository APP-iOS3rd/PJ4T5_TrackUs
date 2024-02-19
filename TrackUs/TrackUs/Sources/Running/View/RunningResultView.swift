//
//  RunningResultView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct RunningResultView: View {
    @EnvironmentObject var router: Router
    @State private var showingPopup = false
    
    var body: some View {
        VStack {
            LocationMeMapView()
            
            VStack {
                VStack(spacing: 20) {
                    
                    RoundedRectangle(cornerRadius: 27)
                        .fill(.indicator)
                        .frame(
                            width: 32,
                            height: 4
                        )
                    
                    Text("러닝 결과")
                        .customFontStyle(.gray1_SB20)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("운동량")
                            .customFontStyle(.gray1_R16)
                        
                        HStack {
                            Image(.shose)
                            VStack(alignment: .leading) {
                                Text("킬로미터")
                                Text("-")
                            }
                            Spacer()
                            
                            
                            Text("-")
                                .customFontStyle(.gray1_R12)
                            
                        }
                        
                        HStack {
                            Image(.fire)
                            VStack(alignment: .leading) {
                                Text("소모 칼로리")
                                Text("-")
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text("-")
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.time)
                            VStack(alignment: .leading) {
                                Text("러닝 타임")
                                Text("-")
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text("-")
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.pace)
                            VStack(alignment: .leading) {
                                Text("페이스")
                                Text("-")
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text("-")
                                .customFontStyle(.gray1_R12)
                        }
                    }
                    
                    HStack {
                        Text("")
                            .customFontStyle(.gray1_R14)
                        Spacer()
                    }
                    
                    
                    HStack(spacing: 28) {
                        MainButton(active: true, buttonText: "리포트로 이동", buttonColor: .gray1, minHeight: 45) {
                            router.popToRoot()
                        }
                        
                        MainButton(active: true, buttonText: "러닝 기록 저장", buttonColor: .main, minHeight: 45) {
                            showingPopup = true
                        }
                        
                    }
                }
                .padding(20)
            }
            .zIndex(2)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(
                .rect (
                    topLeadingRadius: 12,
                    topTrailingRadius: 12
                )
            )
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        .ignoresSafeArea(.keyboard)
        .preventGesture()
        .popup(isPresented: $showingPopup) {
            SaveDataPopup(showingPopup: $showingPopup)
        } customize: {
            $0
                .backgroundColor(.black.opacity(0.3))
                .isOpaque(true)
                .dragToDismiss(false)
                .closeOnTap(false)
        }
    }
}

struct SaveDataPopup: View {
    @EnvironmentObject var router: Router
    @State var title: String = ""
    @Binding var showingPopup: Bool
    @FocusState private var titleTextFieldFocused: Bool
    
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("러닝 기록 저장")
                    .customFontStyle(.gray1_B16)
                
                Text("러닝기록 저장을 위해\n러닝의 이름을 설정해주세요.")
                    .customFontStyle(.gray1_R14)
                    .padding(.top, 8)
                
                VStack {
                    TextField("저장할 러닝 이름을 입력해주세요.", text: $title)
                        .customFontStyle(.gray1_R12)
                        .padding(8)
                        .frame(height: 32)
                        .textFieldStyle(PlainTextFieldStyle())
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(titleTextFieldFocused ? .main : .gray2))
                        .focused($titleTextFieldFocused)
                }
                .padding(.top, 16)
                
                HStack {
                    Button(action: {
                        showingPopup = false
                    }, label: {
                        Text("취소")
                            .customFontStyle(.main_R16)
                            .frame(minHeight: 40)
                            .padding(.horizontal, 20)
                            .overlay(Capsule().stroke(.main))
                    })
                    
                    MainButton(active: true, buttonText: "확인", minHeight: 40) {
                       
                    }
                    
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(12)
        .padding(.horizontal, 60)
    }
}
