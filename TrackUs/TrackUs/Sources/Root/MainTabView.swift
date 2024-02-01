//
//  MainTabView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var router: Router
    @State private var selectedTab: Tab = .running

    enum Tab {
        case running, recruitment, chatting, report, profile
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            TabView(selection: $selectedTab) {
                RunningView()
                    .tabItem {
                        if selectedTab == .running {
                            Image("Running.fill")
                        } else {
                            Image("Running")
                        }
                        Text("러닝")
                    }
                    .tag(Tab.running)
                
                RecruitmentView()
                    .tabItem {
                        if selectedTab == .recruitment {
                            Image("Recruitment.fill")
                        } else {
                            Image("Recruitment")
                        }
                        Text("모집")
                    }
                    .tag(Tab.recruitment)
                
                ChattingView()
                    .tabItem {
                        if selectedTab == .chatting {
                            Image("Chatting.fill")
                        } else {
                            Image("Chatting")
                        }
                        Text("채팅")
                    }
                    .tag(Tab.chatting)
                
                ReportView()
                    .tabItem {
                        if selectedTab == .report {
                            Image("Report.fill")
                        } else {
                            Image("Report")
                        }
                        Text("리포트")
                    }
                    .tag(Tab.report)
                
                MyProfileView()
                    .tabItem {
                        if selectedTab == .profile {
                            Image("Profile.fill")
                        } else {
                            Image("Profile")
                        }
                        Text("프로필")
                    }
                    .tag(Tab.profile)
            }
            .onAppear {
                selectedTab = .running
            }
        }
    }
}

#Preview {
    MainTabView()
}
