//
//  AuthenticationViewModel.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import CryptoKit

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
class AuthenticationViewModel: NSObject, ObservableObject {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage: String = ""
    @Published var user: User?
    @Published var newUser: Bool = false
    @Published var checkBool: Bool?
    
    
    // apple login
    var window: UIWindow?
    fileprivate var currentNonce: String?

    
    override init() {
        super.init()
        registerAuthStateHandler()
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                if user == nil {
                    self.authenticationState = .unauthenticated
                } else {
                    Task{
                        let check = try await Firestore.firestore().collection("users")
                            .whereField("uid", isEqualTo: user!.uid).getDocuments()
                        if check.isEmpty {
                            self.authenticationState = .signUpcating
                        }else {
                            self.authenticationState = .authenticated
                        }
                    }
                }
            }
        }
    }
    
    // 닉네임 중복 체크
    func checkUser(username: String) async -> Bool {
        do {
            let querySnapshot = try await Firestore.firestore().collection("users")
                .whereField("username", isEqualTo: username).getDocuments()
            if querySnapshot.isEmpty {
                return true
            } else {
                return false
            }
        } catch {
            return true
        }
    }
    
    // MARK: - 로그아웃
    func logOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - 회원탈퇴
    func deleteAccount() async -> Bool {
        do {
            if let uid = Auth.auth().currentUser?.uid {
                try await user?.delete()
                try await Firestore.firestore().collection("users").document(uid).delete()
                print("Document successfully removed!")
            }
            self.authenticationState = .unauthenticated
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            self.authenticationState = .unauthenticated
            print("ErrorMessage : ", errorMessage)
            print("deletAccount Error!!")
            return false
        }
    }
}

//enum AuthenticationError: Error {
//  case tokenError(message: String)
//}

extension AuthenticationViewModel {
    // MARK: - 구글 로그인
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("client ID 없음")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("root view controller 없음")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            let user = userAuthentication.user
            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token 누락") }
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            try await Auth.auth().signIn(with: credential)
            return true
        }
        catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return false
        }
    }
}


// MARK: - apple 로그인
extension AuthenticationViewModel{
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // Apple Login 필요 함수
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension AuthenticationViewModel: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Task {
                do {
                    try await Auth.auth().signIn(with: credential)
                }
                catch {
                    print("Error authenticating: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}

extension AuthenticationViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window ?? UIWindow()
    }
}
