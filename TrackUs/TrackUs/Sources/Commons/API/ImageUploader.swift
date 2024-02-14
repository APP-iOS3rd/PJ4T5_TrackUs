//
//  ImageUploader.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/13.
//

import UIKit
import Firebase
import FirebaseStorage

// enum을 활용하여 스토리지 경로를 반환
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

// UIKit의 UIImage를 사용해야 JPEG 형식으로 압축이 가능
struct ImageUploader {
    
    static func uploadImage(image: UIImage, type: UploadType,  completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let ref = type.filePath
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        ref.putData(imageData, metadata: metadata) { meta, error in
            if let error = error {
                print("DEBUG: Failed to upload image : \(error.localizedDescription)")
                return
            }
            
            print("Succesfully upload image...")
            ref.downloadURL { url, _ in
                guard let url = url?.absoluteString else { return }
                completion(url)
            }
        }
    }
}
