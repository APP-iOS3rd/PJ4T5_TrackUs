//
//  ContentView.swift
//  TrackUs
//
//  Created by 박소희 on 1/29/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        VStack{
            switch viewModel.authenticationState {
                // 로그인
            case .unauthenticated, .authenticating:
                VStack {
                    LoginView()
                        .environmentObject(viewModel)                }
                //이전에 로그인 했을경우
            case .signUpcating:
                VStack{
                    SignUpView()
                        .environmentObject(viewModel)
                }
            case .authenticated:
                VStack {
                    MainTabView()
                        .environmentObject(viewModel)
                }
            }
        }
        .animation(.easeIn(duration: 0.15), value: viewModel.authenticationState)
    }
}

#Preview {
    ContentView()
}
