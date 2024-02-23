//
//  UserProfileViewModel.swift
//  TrackUs
//
//  Created by 윤준성 on 2/19/24.
//

import Foundation
import Firebase
import FirebaseStorage

class UserProfileViewModel: ObservableObject {
    static let shared = UserProfileViewModel()
    
    @Published var otherUserInfo: UserInfo = UserInfo()
    
    public init() {}

    func getOtherUserInfo(for userId: String) {
        Firestore.firestore().collection("users").document(userId).getDocument { [weak self] (snapshot, error) in
            if let error = error {
                print("Error getting user document: \(error)")
                return
            }
            
            guard let document = snapshot else {
                print("User document not found")
                return
            }
            
            do {
                let userInfo = try document.data(as: UserInfo.self)
                self?.otherUserInfo = userInfo
                if let profileImageUrl = userInfo.profileImageUrl {
                    self?.downloadImageFromStorage(uid: userId, imageUrl: profileImageUrl)
                }
            } catch let error {
                print("Error decoding user document: \(error)")
            }
        }
    }

    func downloadImageFromStorage(uid: String, imageUrl: String) {
        let ref = FirebaseManger.shared.storage.reference(forURL: imageUrl)
        
        ref.getData(maxSize: 1 * 1024 * 1024)  { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else {
                if let imageData = data, let image = UIImage(data: imageData) {
                    self.otherUserInfo.image = image
                } else {
                    print("Failed to convert data to UIImage")
                }
            }
        }
    }

}
