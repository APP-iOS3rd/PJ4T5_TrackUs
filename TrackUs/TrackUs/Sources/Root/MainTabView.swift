//
//  MainTabView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TabView {
                RunningView()
                    .tabItem {
                        Label("러닝", systemImage: "figure.run")
                    }
                    
                ReportView()
                    .tabItem {
                        Label("리포트", systemImage: "chart.bar")
                    }
                    
                MyProfileView()
                    .tabItem {
                        Label("마이프로필", systemImage: "person.circle")
                    }
            }
        }
    }
}

#Preview {
    MainTabView()
}
