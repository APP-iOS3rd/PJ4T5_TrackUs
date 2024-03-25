//
//  SettingsView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var router: Router
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @State private var showingLogoutAlert = false
    
    
    
    var body: some View {
        VStack {
            ScrollView {
                MenuItems {
                    Text("앱 정보")
                        .customFontStyle(.gray1_SB16)
                } content: {
                    MenuItem(title: "버전정보", label: "v.1.0.0")
                    Button {
                        router.present(sheet: .webView(url: Constants.WebViewUrl.TEAM_INTRO_URL))
                    } label: {
                        MenuItem(title: "팀 트랙어스", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                MenuItems {
                    Text("계정 관련")
                        .customFontStyle(.gray1_SB16)
                } content: {
                    Button(action: logoutButtonTapped) {
                        MenuItem(title: "로그아웃")
                    }
                    HStack{
                        Button(action: {
                            router.push(.withDrawal)
                        }, label: {
                            Text("회원탈퇴")
                                .customFontStyle(.caution_R16)
                        })
                        Spacer()
                    }
                }
            }
        }
        .customNavigation {
            NavigationText(title: "설정")
        } left: {
            NavigationBackButton()
        }
        .alert(isPresented: $showingLogoutAlert) {
                    Alert(title: Text("로그아웃 완료"), message: Text("로그아웃이 완료되었습니다."), dismissButton: .default(Text("확인")))
                }
        
        
    }
    
    func logoutButtonTapped() {
        // 테스트용
        authViewModel.logOut()
        //viewModel.authenticationState = .unauthenticated
        showingLogoutAlert = true
        router.popToRoot()
    }
    
    func withdrawalButtonTapped() {
    }
}

#Preview {
    SettingsView()
}
