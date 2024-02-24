//
//  ChatListViewModel.swift
//  TrackUs
//
//  Created by 최주원 on 2/23/24.
//

import Foundation
import FirebaseFirestore

class ChatListViewModel: ObservableObject {
    
    // 채팅방 정보
    @Published var chatRooms: [ChatRoom] = []
    @Published var users: [String: Member] = [:]
    
    // 같은 채팅방 쓰는 맴버들 정보
    //@Published var members: [Member] = []
    
    // 변환 방식 -> chatRoom -> currentUId 포함된 맴버 목록(uid) 불러오기 -> 포함된 userInfo 리스너 추가?
    private let ref = FirebaseManger().firestore.collection("chatRoom")
    
    // 채팅방 listener 추가
    func subscribeToUpdates() {
        guard let currentUId = FirebaseManger().auth.currentUser?.uid else { return }
        ref.whereField("members", arrayContains: currentUId).addSnapshotListener() { [weak self] (snapshot, _) in
            self?.storeChatRooms(snapshot, currentUId)
        }
        
    }
    
    // 채팅방 Firebase 정보 가져오기
    private func storeChatRooms(_ snapshot: QuerySnapshot?, _ currentUId: String) {
        DispatchQueue.main.async { [weak self] in
            self?.chatRooms = snapshot?.documents
                .compactMap { [weak self] document in
                    do {
                        let firestoreChatRoom = try document.data(as: FirestoreChatRoom.self)
                        return self?.makeChatRooms(document.documentID, firestoreChatRoom, currentUId)
                    } catch {
                        print(error)
                    }

                    return nil
                }.sorted {
                    if let date1 = $0.latestMessage?.timestemp, let date2 = $1.latestMessage?.timestemp {
                        return date1 > date2
                    }
                    return $0.title < $1.title
                }
            ?? []
        }
    }
    
    // ChatRoom타입에 맞게 변환
    private func makeChatRooms(_ id: String, _ firestoreChatRoom: FirestoreChatRoom, _ currentUId: String) -> ChatRoom {
        var message: LatestMessageInChat? = nil
        if let flm = firestoreChatRoom.latestMessage {
            message = LatestMessageInChat(
                //senderName: user.name,
                timestemp: flm.timestemp,
                text: flm.text.isEmpty ? nil : flm.text
            )
        }
        let members = firestoreChatRoom.members
        _ = firestoreChatRoom.members.map { memberId in
            memberUserInfo(uid: memberId)
        }
        let chatRoom = ChatRoom(
            id: id,
            title: firestoreChatRoom.title,
            members: members,
            nonSelfMembers: members.filter { $0 != currentUId },
            // 다 불러와야하나??? 저장때문에 불러오는거 아님 본인꺼만 불러오면 되는거 아닌가
            usersUnreadCountInfo: firestoreChatRoom.usersUnreadCountInfo,
            gruop: firestoreChatRoom.gruop,
            latestMessage: message
        )
        return chatRoom
    }
    
    // 리스너 추가? 아님 별도로 기록?
    // 채팅방 멤버 닉네임, 프로필사진url 불러오기
    private func memberUserInfo(uid: String) {
        FirebaseManger.shared.firestore.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else { return }
            do {
                let userInfo = try document.data(as: UserInfo.self)
                self.users[uid] = Member(uid: uid, userName: userInfo.username, profileImageUrl: userInfo.profileImageUrl)
            } catch {
                print("Error decoding document: \(error)")
            }
        }
    }
}
