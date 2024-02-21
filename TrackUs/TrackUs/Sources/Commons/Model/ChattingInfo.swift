//
//  ChattingInfo.swift
//  TrackUs
//
//  Created by 최주원 on 2/19/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatRoom: Codable, Identifiable {
    var id: String  // 모집글 id와 동일
    var title: String    // 채팅방 이름
    var members: [String: Member] // Firebase Realtime Database에는 배열이 아닌 딕셔너리로 저장됩니다.
    var messages: [String: Message]? // Firebase Realtime Database에는 배열이 아닌 딕셔너리로 저장됩니다.
        
    init(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let id = value["id"] as? String,
              let title = value["title"] as? String,
              let membersData = value["members"] as? [String: Any] else {

            fatalError("Failed to initialize ChatRoom from DataSnapshot")
        }
        
        var members = [String: Member]()
        for (key, memberData) in membersData {
            if let memberDict = memberData as? [String: Any] {
                let member = Member(dictionary: memberDict)
                members[key] = member
            }
        }
        
        self.id = id
        self.title = title
        self.members = members
        
        // messages는 optional이므로 필요에 따라 초기화
        if let messagesData = value["messages"] as? [String: Any] {
            var messages = [String: Message]()
            for (key, messageData) in messagesData {
                if let messageDict = messageData as? [String: Any] {
                    let message = Message(dictionary: messageDict)
                    messages[key] = message
                }
            }
            self.messages = messages
        } else {
            self.messages = nil
        }
    }
//    var members: [Member]
//    var messages: [Message]?
//    
    init(id: String, title: String, members: [String: Member]) {
        self.id = id
        self.title = title
        self.members = members
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "members": members
        ]
    }
    
}

struct Member: Codable {
    var owner: Bool
    var uid: String
    var userName: String
    var profileImageUrl: String?
    
    init(owner: Bool = false,uid: String, userName: String, profileImageUrl: String? = nil) {
        self.owner = owner
        self.uid = uid
        self.userName = userName
        self.profileImageUrl = profileImageUrl
    }
    
    init(dictionary: [String: Any]) {
        self.owner = dictionary["owner"] as? Bool ?? false
        self.uid = dictionary["uid"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}

struct Message: Codable {
    var userUid: String
    var userName: String
    var profileImageUrl: String?
    var timestamp: Timestamp
    var imageUrl: String?
    var message: String?
    
    
    /// 메세지용
    init(userUid: String, message: String, profileImageUrl: String?, userName: String,
         createdAt: Timestamp = Timestamp(date: Date())) {
        
        self.userUid = userUid
        self.profileImageUrl = profileImageUrl
        self.userName = userName
        self.timestamp = createdAt
        self.message = message
    }
    
    /// 이미지용
    init(userUid: String, imageUrl: String, profileImageUrl: String?, userName: String,
         createdAt: Timestamp = Timestamp(date: Date())) {
        
        self.userUid = userUid
        self.profileImageUrl = profileImageUrl
        self.imageUrl = imageUrl
        self.userName = userName
        self.timestamp = createdAt
    }
    
    init(dictionary: [String: Any]) {
        self.userUid = dictionary["userUid"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.imageUrl = dictionary["imageUrl"] as? String
        self.message = dictionary["message"] as? String
    }
}
