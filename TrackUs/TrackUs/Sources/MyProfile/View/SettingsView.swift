//
//  SettingsView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

struct SettingsView: View {
    @State private var isShownModal = false
    var body: some View {
        VStack {
            ScrollView {
                MenuItems {
                    Text("앱 정보")
                        .customFontStyle(.gray1_SB16)
                } content: {
                    MenuItem(title: "버전정보", label: "v.1.0.0")
                    Button {
                        isShownModal.toggle()
                    } label: {
                        MenuItem(title: "팀 트랙어스", image: .init(.chevronRight))
                    }
                    .sheet(isPresented: $isShownModal, content: {
                        WebViewSurport(url: Constants.WebViewUrl.TEAM_INTRO_URL)
                    })
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
                    
                    NavigationLink(value: "WithdrawalView") {
                        HStack {
                            Text("회원탈퇴")
                                .customFontStyle(.gray1_SB16)
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
    
    func logoutButtonTapped() {}
    
    func withdrawalButtonTapped() {}
}

#Preview {
    SettingsView()
}
