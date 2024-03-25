//
//  ImageUploader.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/13.
//

import UIKit
import Firebase
import FirebaseStorage

/**
 Firebase Storage 이미지 업로더
 */
struct ImageUploader {
    enum UploadType {
        case profile
        case map
        
        var filePath: StorageReference {
            let filename = NSUUID().uuidString
            switch self {
            case .profile:
                return Storage.storage().reference(withPath: "/profile_images/\(filename)")
            case .map:
                return Storage.storage().reference(withPath: "/mapImage/\(filename)")
            }
        }
    }
    static func uploadImage(image: UIImage, type: ImageUploader.UploadType,  completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let ref = type.filePath
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        ref.putData(imageData, metadata: metadata) { meta, error in
            if let error = error {
                print("DEBUG: Failed to upload image : \(error.localizedDescription)")
                return
            }
            
            
            ref.downloadURL { url, _ in
                guard let url = url?.absoluteString else { return }
                print("Succesfully upload image...")
                completion(url)
            }
        }
    }
}
