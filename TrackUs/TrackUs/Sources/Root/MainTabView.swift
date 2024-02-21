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
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.shadowColor = .divider
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TabView(selection: $router.selectedIndex) {
                // Sheet 애니메이션 끊김현상으로 일시적으로 VStack으로 래핑
                VStack {
                    router.buildScreen(page: .running)
                }
                .tabItem {
                    Image("Running")
                        .renderingMode(.template)
                    Text("러닝")
                }
                .tag(Tab.running)
                                
                router.buildScreen(page: .chat)
                    .tabItem {
                        Image("Chatting")
                            .renderingMode(.template)
                        Text("채팅")
                    }
                    .tag(Tab.chat)
                
                router.buildScreen(page: .report)
                    .tabItem {
                        Image("Report")
                            .renderingMode(.template)
                        Text("리포트")
                    }
                    .tag(Tab.report)
                
                
                router.buildScreen(page: .profile)
                    .tabItem {
                        Image("Profile")
                            .renderingMode(.template)
                        Text("프로필")
                    }
                    .tag(Tab.profile)
            }
            .navigationDestination(for: Page.self, destination: { page in
                router.buildScreen(page: page)
            })
            .sheet(item: $router.sheet, content: { sheet in
                router.buildScreen(sheet: sheet)
            })
            .fullScreenCover(item: $router.fullScreenCover, content: { fullScreenCover in
                router.buildScreen(fullScreenCover: fullScreenCover)
            })
            
            .onChange(of: router.selectedIndex) { _ in
                HapticManager.instance.impact(style: .light)
            }
        }
    }
}

#Preview {
    MainTabView()
}
