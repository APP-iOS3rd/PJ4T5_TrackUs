//
//  AuthenticationViewModel.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import CryptoKit
import SwiftUI

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case signUpcating
    case authenticated
}

enum AuthenticationError: Error {
    case tokenError(message: String)
}

class FirebaseManger: NSObject {
    static let shared = FirebaseManger()
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    //var flow: SignUpFlow = .nickname
    
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}

@MainActor
class AuthenticationViewModel: NSObject, ObservableObject {
    static let shared = AuthenticationViewModel()
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage: String = ""
    @Published var user: User?
    @Published var newUser: Bool = false
    @Published var checkBool: Bool?
    @Published var userInfo: UserInfo = UserInfo()
    
    
    // apple login 
    var window: UIWindow?
    fileprivate var currentNonce: String?

    
    private override init() {
        super.init()
        registerAuthStateHandler()
        //super.self.userInfo = UserInfo()
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
                            self.getMyInformation()
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

// MARK: - SNS Login
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

// MARK: - 사용자 정보 관련
extension AuthenticationViewModel {
    
    // MARK: - 이미지 저장 부분 (이미지 저장 -> 사용자 저장 순)
    func storeUserInfoInFirebase() {
        // 이미지 유무 확인 후 저장
        guard let image = self.userInfo.image else {
            self.userInfo.profileImageUrl = nil
            self.storeUserInformation()
            return
        }
         
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            return }
        //let ref = FirebaseManger.shared.storage.reference(withPath: uid)
        let ref = FirebaseManger.shared.storage.reference().child("usersImage/\(uid)")
        
        // 이미지 크기 줄이기 (용량 축소)
        guard let resizedImage = image.resizeWithWidth(width: 300) else {
            return }
        guard let  jpegData = resizedImage.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        // 이미지 포맷
        ref.putData(jpegData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Failed to push image to Storage: \(error)")
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error{
                    print("Failed to retrieve downloadURL: \(error)")
                    return
                }
                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                
                // 이미지 url 저장
                guard let url = url else {return}
                self.userInfo.profileImageUrl = url.absoluteString
                // firestore 저장
                self.storeUserInformation()
            }
        }
    }
    // MARK: - 사용자 정보 저장 - 위 이미지 저장함수와 순차적으로 사용
    private func storeUserInformation() {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            return }
        // 해당부분 자료형 지정 필요
        let userData = ["uid": uid,
                        "username": userInfo.username,
                        "weight": userInfo.weight as Any,
                        "height": userInfo.height as Any,
                        "age": userInfo.age as Any,
                        "gender": userInfo.gender as Any,
                        "isProfilePublic": userInfo.isProfilePublic,
                        "isProSubscriber": false,
                        "profileImageUrl": userInfo.profileImageUrl as Any,
                        "setDailyGoal": userInfo.setDailyGoal as Any,
                        "runningStyle": userInfo.runningStyle as Any] as [String : Any]
        FirebaseManger.shared.firestore.collection("users").document(uid).setData(userData){ error in
            if error != nil {
                print("@@@@@@ error 1 @@@@@@")
                return
            }
            print("success")
        }
    }
    
    // MARK: - 사용자 본인 정보 불러오기
    func getMyInformation(){
        
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            print("error uid")
            return
        }
        FirebaseManger.shared.firestore.collection("users").document(uid).getDocument { [self] (snapshot, error) in
            
            if let error = error {
                print("Error getting documents: \(error)")
            }else{
                guard let _ = snapshot?.description else {return}
                let decoder =  JSONDecoder()
                do {
                    let data = snapshot?.data()
                    let jsonData = try JSONSerialization.data(withJSONObject:data ?? "")
                    self.userInfo = try decoder.decode(UserInfo.self, from: jsonData)
                    downloadImageFromStorage(uid: userInfo.uid)
                } catch let err {
                    print("err: \(err)")
                }
                print(self.userInfo)
            }
        }
    }
    
    func downloadImageFromStorage(uid: String) {
        guard let profileImageUrl = self.userInfo.profileImageUrl else { 
            print("Url 없음 - downloadImageFromStorage")
            return
        }
        print("Url 있음 - ", profileImageUrl)
        let ref = FirebaseManger.shared.storage.reference(forURL: profileImageUrl)
//
//        let storageRef = storage.reference(forURL: url.absoluteString)
        ref.getData(maxSize: 1 * 1024 * 1024)  { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else {
                // Data for "images/island.jpg" is returned
                self.userInfo.image = UIImage(data: data!)
            }
        }
    }
    

}

// MARK: - 이미지 수정 부분
// Image -> UIImage로 변환
extension Image {
    func asUIImage() -> UIImage {
        // Image를 UIImage로 변환하는 확장 메서드
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let size = controller.view.intrinsicContentSize
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        
        return image
    }
}


// UIImage 사진 크기 축소
extension UIImage {
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
