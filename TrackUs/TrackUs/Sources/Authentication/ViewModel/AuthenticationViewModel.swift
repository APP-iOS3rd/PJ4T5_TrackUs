//
//  AuthenticationViewModel.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import Foundation
import Firebase


enum AuthenticationState {
    case unauthenticated
    case authenticating
    case signUpcating
    case authenticated
}


enum AuthenticationError: Error {
  case tokenError(message: String)
}

@MainActor
class LoginViewModel: ObservableObject {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage: String = ""
    //@Published var user: Firebase.User?
    @Published var displayName: String = ""
    @Published var newUser: Bool = false
    
//    @Published var userInfo: User
//    
//    init() {
//        //self.userInfo = User()
//        registerAuthStateHandler()
//    }
//    
//    private var authStateHandler: AuthStateDidChangeListenerHandle?
//    
//    func registerAuthStateHandler() {
//        if authStateHandler == nil {
//            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
//                self.user = user
//                if user == nil {
//                    // user가 없으면서 newUser가 false일 때
//                    self.authenticationState = .unauthenticated
//                } else if self.newUser {
//                    // user가 있고, newUser가 true일 때
//                    self.authenticationState = .signUpcating
//                } else {
//                    // user가 있고, newUser가 false일 때
//                    self.authenticationState = .authenticated
//                }
//                //self.authenticationState = user == nil ? .unauthenticated : .authenticated
//                self.displayName = user?.email ?? ""
//            }
//        }
//    }
    // ui test용
    func signup() {
        self.authenticationState = .signUpcating
    }
    
    // ui test용
    func login() {
        self.authenticationState = .authenticated
    }
    
    // MARK: - 로그아웃
    func logOut() {
        self.authenticationState = .unauthenticated
//        do {
//            try Auth.auth().signOut()
//            self.authenticationState = .unauthenticated
//        }
//        catch {
//            print(error)
//            errorMessage = error.localizedDescription
//        }
    }
    
    // MARK: - 회원탈퇴
//    func deleteAccount() async -> Bool {
//        do {
//            try await user?.delete()
//            self.authenticationState = .unauthenticated
//            return true
//        }
//        catch {
//            errorMessage = error.localizedDescription
//            self.authenticationState = .unauthenticated
//            print("deletAccount Error!!")
//            return false
//        }
//    }
}

//enum AuthenticationError: Error {
//  case tokenError(message: String)
//}
