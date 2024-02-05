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
                // Sheet 애니메이션 끊김현상으로 일시적으로 VStack으로 래핑
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
            .navigationDestination(for: String.self) { screenName in
                switch screenName {
                case "ProfileEditView":
                    ProfileEditView()
                case "SettingsView":
                    SettingsView()
                case "RunningRecordView":
                    RunningRecordView()
                case "TermsOfService":
                    WebViewSurport(url: Constants.WebViewUrl.TERMS_OF_SERVICE_URL)
                        .customNavigation {
                            NavigationText(title: "서비스 이용약관")
                        } left: {
                            NavigationBackButton()
                        }
                case "FAQView":
                    FAQView()
                case "WithdrawalView":
                    Withdrawal()
                case "TeamIntroView":
                    TeamIntroView()
                case "OpenSourceLicense":
                    WebViewSurport(url: Constants.WebViewUrl.OPEN_SOURCE_LICENSE_URL)
                        .customNavigation {
                            NavigationText(title: "오픈소스/라이센스")
                        } left: {
                            NavigationBackButton()
                        }
                    
                case "ServiceRequest":
                    WebViewSurport(url: Constants.WebViewUrl.SERVICE_REQUEST_URL)
                        .customNavigation {
                            NavigationText(title: "문의하기")
                        } left: {
                            NavigationBackButton()
                        }
                case "RunningLiveView":
                    RunningLiveView()
                default:
                    EmptyView()
                }
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
