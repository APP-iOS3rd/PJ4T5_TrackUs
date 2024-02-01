//
//  SettingsView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: LoginViewModel
    var body: some View {
        VStack {
            ScrollView {
                MenuItems(sectionTitle: "앱 정보") {
                    MenuItem(title: "버전정보", label: "v.1.0.0")
                    NavigationLink(value: "TeamIntroView") {
                        MenuItem(title: "팀 트랙어스", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                
                MenuItems(sectionTitle: "계정 관련") {
                    Button(action: logoutButtonTapped) {
                        MenuItem(title: "로그아웃")
                    }
                    
                    NavigationLink(value: "WithdrawalView") {
                        HStack {
                            Text("회원탈퇴")
                                .customFontStyle(.caution_R16)
                            Spacer()
                        }
                    }
                }
            }
        }
        .customNavigation {
            NavigationText(title: "설정")
        } left: {
            NavigationBackButton()
        }
        
    }
    
    func logoutButtonTapped() {
        // 테스트용
        viewModel.authenticationState = .unauthenticated
    }
    
    func withdrawalButtonTapped() {}
}

#Preview {
    SettingsView()
}
