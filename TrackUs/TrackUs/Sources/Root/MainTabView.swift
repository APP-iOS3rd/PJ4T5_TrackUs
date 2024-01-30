//
//  MainTabView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI

    enum selects{
        case none
        case one
        case two
        case three
    }
struct MainTabView: View {
    @EnvironmentObject var router: Router
    @State private var selected: selects = .none
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TabView {
                VStack{
                    SelectButton(text: "첫번째", selected: selected == .one, widthSize: 194){
                        selected = .one
                        print(selected == .one)
                    }
                    SelectButton(text: "두번째", selected: selected == .two, widthSize: 194){
                        selected = .two
                        print("====\(selected)====")
                        print(selected == .two)
                    }
                    SelectButton(text: "세번째", selected: selected == .three, widthSize: 194){
                        selected = .three
                        print("====\(selected)====")
                        print(selected == .three)
                    }
                }
                    .tabItem {
                        Label("러닝", systemImage: "figure.run")
                    }
                
                RunningView()
                    .tabItem {
                        Label("러닝", systemImage: "figure.run")
                    }
                
                ReportView()
                    .tabItem {
                        Label("리포트", systemImage: "chart.bar")
                    }
                
//                MyProfileView()
//                    .tabItem {
//                        Label("마이프로필", systemImage: "person.circle")
//                    }
            }
        }
    }
}

#Preview {
    MainTabView()
}
