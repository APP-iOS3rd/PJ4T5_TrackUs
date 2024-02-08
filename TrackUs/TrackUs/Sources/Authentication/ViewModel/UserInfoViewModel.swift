//
//  UserInfoViewModel.swift
//  TrackUs
//
//  Created by 최주원 on 2/2/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

// Model쪽으로 이후 수정
struct UserInfo : Decodable {
    
    var uid: String
    var username: String
    var weight: Int?
    var height: Int?
    var age: Int?
    var gender: Bool?
    var isProfilePublic: Bool
    var isProSubscriber: Bool
    var profileImageUrl: String?
    var setDailyGoal: Double?
    var runningOption: String?
    
    init(){
        self.uid = ""
        self.username = ""
        self.isProfilePublic = false
        self.isProSubscriber = false
    }
    
    enum CodingKeys:String, CodingKey {
        case uid = "uid"
        case username = "username"
        case weight = "weight"
        case height = "height"
        case age = "age"
        case gender = "gender"
        case isProfilePublic = "isProfilePublic"
        case isProSubscriber = "isProSubscriber"
        case profileImageUrl = "profileImageUrl"
        case setDailyGoal = "setDailyGoal"
        case runningOption = "runningOption"
    }
}

class FirebaseManger: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    var flow: SignUpFlow = .nickname
    
    static let shared = FirebaseManger()
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}

class UserInfoViewModel: ObservableObject {
    static let shared = UserInfoViewModel()
    
    @Published var userInfo: UserInfo
    
    init() {
        self.userInfo = UserInfo()
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
    // MARK: - 사용자 정보 저장
    func storeUserInformation() {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            return }
        // 해당부분 자료형 지정 필요
        let userData = ["uid": uid,
                        "username": userInfo.username,
                        "weight": userInfo.weight ?? "",
                        "height": userInfo.height ?? "",
                        "age": userInfo.age ?? "",
                        "gender": userInfo.gender ?? "",
                        "isProfilePublic": userInfo.isProfilePublic,
                        "isProSubscriber": false,
                        "profileImageUrl": userInfo.profileImageUrl ?? "",
                        "setDailyGoal": userInfo.setDailyGoal ?? "",
                        "runningOption": userInfo.runningOption ?? ""] as [String : Any]
        FirebaseManger.shared.firestore.collection("users").document(uid).setData(userData){ error in
            if error != nil {
                print("@@@@@@ error 1 @@@@@@")
                return
            }
            print("success")
            
        }
    }
    
    func getMyInformation(){
        
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            print("error uid")
            return
        }
        FirebaseManger.shared.firestore.collection("users").document(uid).getDocument { (snapshot, error) in
            //var userInfo: UserInfo = []
            
            if let error = error {
                print("Error getting documents: \(error)")
            }else{
                guard let _ = snapshot?.description else {return}
                let decoder =  JSONDecoder()
                do {
                    let data = snapshot?.data()
                    let jsonData = try JSONSerialization.data(withJSONObject:data ?? "")
                    self.userInfo = try decoder.decode(UserInfo.self, from: jsonData)
                    //userInfo.append(roadInfo)
                } catch let err {
                    print("err: \(err)")
                }
                //completionHandler(roadInfos)
                print(self.userInfo)
            }
        }
    }
    
    
    // MARK: - 이미지 저장 부분
    func persistImageToStorage(image: Image?) {
        // 사용자 uid 받아오기
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            return }
        let ref = FirebaseManger.shared.storage.reference(withPath: uid)
        
        // 이미지 크기 줄이기
        guard let resizedImage = image?.asUIImage().resizeWithWidth(width: 700) else {
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
            }else{
                print("@@@@@ 이미지 업로드 성공 @@@@@@@@")
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
            }
        }
    }
}

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


// Image -> UIImage로 변환
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

