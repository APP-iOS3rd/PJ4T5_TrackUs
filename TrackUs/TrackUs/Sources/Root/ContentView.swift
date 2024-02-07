//
//  ContentView.swift
//  TrackUs
//
//  Created by 박소희 on 1/29/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var router: Router
    @StateObject var authViewModel = AuthenticationViewModel.shared
    
    var body: some View {
        VStack{
            switch authViewModel.authenticationState {
                // 로그인
            case .unauthenticated, .authenticating:
                VStack {
                    LoginView()
                }
                //이전에 로그인 했을경우
            case .signUpcating:
                VStack{
                    SignUpView()
                }
            case .authenticated:
                VStack {
                    MainTabView()
                }
            }
        }
        .animation(.easeIn(duration: 0.15), value: authViewModel.authenticationState)
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
