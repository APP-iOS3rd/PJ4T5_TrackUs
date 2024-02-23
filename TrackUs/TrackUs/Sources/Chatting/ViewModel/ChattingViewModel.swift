//
//  ChattingViewModel.swift
//  TrackUs
//
//  Created by 윤준성 on 2/1/24.
//
//
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class ChattingViewModel: ObservableObject {
    static let shared = ChattingViewModel()
    
    private var db = FirebaseManger.shared.firestore.collection("chatRooms")
    private var storageRef = Storage.storage().reference()
    
    @Published var errorMessage = ""
    @Published var chatRooms: [ChatRoom] = []
    @Published var currentChatIndex: Int = 0
    @Published var currentMessages: [Message]? = []
    //@Published var currentChatRoom: ChatRoom = ChatRoom(id: "", title: "", members: [""])
    
    init() {
        fetchChatRooms(forUserUID: FirebaseManger().auth.currentUser?.uid)
    }
    
    // 채팅방 생성
    func createChatRoom(chatRoom: ChatRoom) {
        do {
            try db.document(chatRoom.id).setData(from: chatRoom)
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    // 채팅방 참여
    func joinChatRoom(chatRoomID: String, userUID: String) {
        db.document(chatRoomID).updateData([
            "members": FieldValue.arrayUnion([userUID])
          ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            }
        }
    }
    
    // 채팅방 나가기
    func leaveChatRoom(chatRoomID: String, userUID: String) {
        db.document(chatRoomID).updateData([
            "members": FieldValue.arrayRemove([userUID])
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            }
        }
    }
    
    // 채팅방 삭제하기
    func deleteChatRoom(chatRoomID: String) {
        db.document(chatRoomID).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            }
        }
    }
    
    // 채팅방 불러오기
    func fetchChatRooms(forUserUID userUID: String?) {
        guard let userUID = userUID else { return }
        db.whereField("members", arrayContains: userUID)
            .addSnapshotListener {
                querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                self.chatRooms = documents.compactMap { document in
                    try? document.data(as: ChatRoom.self)
                }
                print(self.chatRooms)
            }
    }
    
    // 채팅방 메세지 불러오기
//    func startListeningMessages() {
//        db.document(currentChatRoom.id).collection("messages")
//            .addSnapshotListener { snapshot, error in
//                guard let snapshot = snapshot else {
//                    print("Error fetching documents: \(error!)")
//                    return
//                }
//                snapshot.documentChanges.forEach { diff in
//                    if diff.type == .added {
//                        if let message = try? diff.document.data(as: Message.self) {
//                            self.chatMessages.append(message)
//                        }
//                    }
//                }
//            }
//    }
    
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
        if chatText.isEmpty { return }
        let messageData: [String: Any] = [
            "userUid": userInfo.uid,
            "message": chatText,
            "userName": userInfo.username,
            "profileImageUrl": userInfo.profileImageUrl as Any,
            "timestamp": Date().timeIntervalSince1970 // 현재 시간을 타임스탬프로 변환
        ]
        //db.document(currentChatRoom.id).collection("messages").addDocument(data: messageData)
        db.document(chatRooms[currentChatIndex].id).updateData([
            "messages": FieldValue.arrayUnion([messageData])
          ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            }
        }
    }
    
    
    /// timestamp -> string 변환
    func formatTransactionTimpestamp(_ timestamp: Timestamp?) -> String {
        if let timestamp = timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            let date = timestamp.dateValue()
            dateFormatter.locale = Locale.current
            let formatted = dateFormatter.string(from: date)
            return formatted
        }
        return ""
    }
}
