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
    @ObservedObject var networkManager = NetworkManager()
    @State private var showAlert = false
    
    var body: some View {
        VStack{
            switch authViewModel.authenticationState {
            case .startapp:
                VStack{
                    Image(.trackusBigLogo)
                        .resizable()
                        .frame(width: 200, height: 65)
                }
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
        .preferredColorScheme(.light)
        .popup(isPresented: $showAlert) {
            NetworkErrorView()
                .frame(width: 300, height: 150)
        } customize: {
            $0
                .backgroundColor(.black.opacity(0.3))
                .isOpaque(true)
        }
        .onReceive(networkManager.$isConnected, perform: { isConnected in
            showAlert = !isConnected
        })
        .disabled(showAlert)
    }
}

#Preview {
    ContentView()
}
