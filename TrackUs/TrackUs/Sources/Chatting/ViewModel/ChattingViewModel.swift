//
//  ChattingViewModel.swift
//  TrackUs
//
//  Created by 윤준성 on 2/1/24.
//
//
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ChattingViewModel: ObservableObject {
    static let shared = ChattingViewModel()
    private var dbRef = Database.database().reference()
    private var storageRef = Storage.storage().reference()
    
    @Published var errorMessage = ""
    @Published var chatRooms: [ChatRoom] = []
    @Published var chatMessages: [Message] = []
    @Published var currentChatRoom: ChatRoom = ChatRoom(id: "", title: "", members: [:])
    
    init() {
        fetchChatRooms(forUserUID: FirebaseManger().auth.currentUser?.uid)
    }
    
    // 채팅방 생성
    func createChatRoom(chatRoom: ChatRoom) {
        let chatRoomRef = dbRef.child("chatRooms").child(chatRoom.id)
        chatRoomRef.setValue(chatRoom.toDictionary())
    }
    
    // 채팅방 참여
    func joinChatRoom(chatRoomID: String, userUID: String) {
        dbRef.child("chatRooms").child(chatRoomID).child("members").updateChildValues([userUID: true])
    }
    
    // 채팅방 나가기
    func leaveChatRoom(chatRoomID: String, userUID: String) {
        dbRef.child("chatRooms").child(chatRoomID).child("members").child(userUID).removeValue()
    }
    
    // 채팅방 삭제하기
    func deleteChatRoom(chatRoomID: String) {
        dbRef.child("chatRooms").child(chatRoomID).removeValue()
    }
    
    // 채팅방 불러오기
    func fetchChatRooms(forUserUID userUID: String?) {
        guard let userUID = userUID else { return }
        dbRef.child("chatRooms")
            .queryOrdered(byChild: "members/\(userUID)")
            .queryEqual(toValue: true)
            .observe(.value, with: { snapshot in
                var rooms: [ChatRoom] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot {
                        let room = ChatRoom(snapshot: snapshot)
                        rooms.append(room)
                    }
                }
                self.chatRooms = rooms
            }
                     )
    }
    
    // 이미지 업로드
    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        let imageRef = storageRef.child("\(UUID().uuidString).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(nil)
                return
            }
            imageRef.downloadURL { url, error in
                completion(url?.absoluteString)
            }
        }
    }
    
    // 채팅 메시지 전송
    func sendChatMessage(chatText: String, userInfo: UserInfo) {
        let messageData: [String: Any] = [
            "userUid": userInfo.uid,
            "message": chatText,
            "userName": userInfo.username,
            "profileImageUrl": userInfo.profileImageUrl as Any,
            "timestamp": ServerValue.timestamp()
        ]
        
        let messageRef = dbRef.child("chatRooms").child(currentChatRoom.id).child("messages").childByAutoId()
        messageRef.setValue(messageData)
    }
    
    // 채팅 메시지 받아오기
    func startListeningMessages(forChatRoom chatRoomID: String) {
        dbRef.child("chatRooms").child(chatRoomID).child("messages")
            .observe(.childAdded) { snapshot in
                guard let messageData = snapshot.value as? [String: Any] else {
                    return
                }
                let message = Message(dictionary: messageData)
                self.chatMessages.append(message)
            }
    }
}
