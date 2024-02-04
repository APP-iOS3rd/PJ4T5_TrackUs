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
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.shadowColor = .divider
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TabView(selection: $selectedTab) {
                VStack {
                    RunningHomeView()
                }
                .tabItem {
                    Image("Running")
                        .renderingMode(.template)
                    Text("러닝")
                }
                .tag(Tab.running)
                
                RecruitmentView()
                    .tabItem {
                        Image("Recruitment")
                            .renderingMode(.template)
                        Text("모집")
                    }
                    .tag(Tab.recruitment)
                
                
                ChattingView()
                    .tabItem {
                        Image("Chatting")
                            .renderingMode(.template)
                        Text("채팅")
                    }
                    .tag(Tab.chatting)
                
                
                ReportView()
                    .tabItem {
                        Image("Report")
                            .renderingMode(.template)
                        Text("리포트")
                    }
                    .tag(Tab.report)
                
                
                MyProfileView()
                    .tabItem {
                        Image("Profile")
                            .renderingMode(.template)
                        Text("프로필")
                    }
                    .tag(Tab.profile)
            }
            .onChange(of: selectedTab) { _ in
                HapticManager.instance.impact(style: .light)
            }
        }
    }
    
    
}

#Preview {
    MainTabView()
}
