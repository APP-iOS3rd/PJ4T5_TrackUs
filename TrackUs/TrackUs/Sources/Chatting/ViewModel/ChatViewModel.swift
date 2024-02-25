//
//  ChatViewModel.swift
//  TrackUs
//
//  Created by 최주원 on 2/23/24.
//

import Foundation
import Firebase

//struct Message: Codable {
//    var userId: String
//    var timestamp: Date
//    var imageUrl: String?
//    var text: String?
//}

class ChatViewModel: ObservableObject {
    
    @Published var currentChatID: String = ""
    @Published var members: [String : Member] = [:]
    @Published var messages: [Message] = []
    @Published var chatRoom: ChatRoom
    
    // 뭐지
    var lock = NSRecursiveLock()
    
    private let ref = FirebaseManger().firestore.collection("chatRoom")
    
    // navigaton 들어갈때 값 받기
    init(currentChatID: String, members: [String : Member], messages: [Message], chatRoom: ChatRoom) {
        self.currentChatID = currentChatID
        self.members = members
        self.messages = messages
        self.chatRoom = chatRoom
    }
    
    init(chatRoom: ChatRoom, users: [String: Member]){
        self.currentChatID = chatRoom.id
        self.chatRoom = chatRoom
        self.members = chatRoom.members.reduce(into: [String: Member]()) { result, uid in
            if let member = users[uid] {
                result[uid] = member
            }
        }
        
        subscribeToUpdates()
    }
    
    
    // 채팅방 리스너
    func subscribeToUpdates() {
        ref.document(currentChatID)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener() { [weak self] (snapshot, _) in
                guard let self = self else { return }
                
                let messages = snapshot?.documents
                    .compactMap { try? $0.data(as: FirestoreMessage.self) }
                    .compactMap { firestoreMessage -> Message? in
                        guard
                            let id = firestoreMessage.id,
                            let timestamp = firestoreMessage.timestamp,
                            let sendMember = self.members[firestoreMessage.userId]
                        else{ return nil }
                        
                        let text = firestoreMessage.text
                        let imageUrl = firestoreMessage.imageUrl
                        
                        return Message(
                            id: id,
                            timestamp: timestamp,
                            imageUrl: imageUrl,
                            text: text,
                            sendMember: sendMember
                        )
                    } ?? []
                self.lock.withLock {
//                    let localMessages = self.messages
//                        .filter { localMessage in
//                            messages.firstIndex { message in
//                                message.id == localMessage.id
//                            } == nil
//                        }
                    self.messages = messages
                        .sorted { $0.timestamp < $1.timestamp } //+ localMessages
                }
                
            }
    }
    // 마지막 메세지 수정
    
    // 채팅방 리스너 종료 -> 나가기
    
    // 채팅 메시지 전송
    func sendChatMessage(chatText: String, image: UIImage? = nil, uid: String) {
        if chatText.isEmpty { return }
        // 이미지 있을 경우
        
        let messageData: [String: Any] = [
            "userId": uid,
            "text": chatText,
            // 이미지 작업 추가하면 해당 수정
            "imageUrl": image as Any,
            "timestamp": Date() // 현재 시간을 타임스탬프로 변환
        ]
        
        let latestMessageData: [String: Any] = [
            "text": chatText,
            // 이미지 작업 추가하면 해당 수정
            "timestamp": Date() // 현재 시간을 타임스탬프로 변환
        ]

        
        let id = UUID().uuidString
        ref.document(currentChatID).collection("messages").document(id).setData(messageData) { [self] error in
            if let error = error {
                print("Error updating document: \(error)")
            }
            bumpUnreadCounters(myuid: uid)
        }
        ref.document(currentChatID)
            .updateData(["latestMessage" : latestMessageData])
    }
    
    // 사용자 메세지 확인 후 초기화 - 채팅방 들어올때
    func resetUnreadCounter(myuid: String) {
        var usersUnreadCountInfo = chatRoom.usersUnreadCountInfo
        usersUnreadCountInfo[myuid] = 0
        ref.document(currentChatID).updateData(["usersUnreadCountInfo" : usersUnreadCountInfo])
    }
    
    // 본인 제외 안읽은 메세지 1개씩 추가 - 메세지 전송때
    func bumpUnreadCounters(myuid: String) {
        var usersUnreadCountInfo = chatRoom.usersUnreadCountInfo
        usersUnreadCountInfo = usersUnreadCountInfo.mapValues { $0 + 1 }
        usersUnreadCountInfo[myuid] = 0
        ref.document(currentChatID).updateData(["usersUnreadCountInfo" : usersUnreadCountInfo])
    }
    
    // 마지막 메세지 변경
    
}
