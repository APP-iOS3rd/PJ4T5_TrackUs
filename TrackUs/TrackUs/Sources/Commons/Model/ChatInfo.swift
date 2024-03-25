//
//  ChattingInfo.swift
//  TrackUs
//
//  Created by 최주원 on 2/19/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

//MARK: - 채팅방 관련 정보
struct ChatRoom: Codable, Identifiable {
    var id: String  // 모집글 id와 동일
    var title: String    // 채팅방 이름
    var group: Bool
    var members: [String]
    var nonSelfMembers: [String]    // 사용자 제외 member
    //var messages: [Message]?
    var usersUnreadCountInfo: [String: Int]     // 신규 메세지 갯수
    public let latestMessage: LatestMessageInChat?  // 최근 메세지
        
    init(id: String, title: String, members: [String], nonSelfMembers: [String],usersUnreadCountInfo: [String: Int]? = nil, group : Bool, latestMessage: LatestMessageInChat? = nil) {
        self.id = id
        self.title = title
        self.members = members
        // 본인 제외 맴버 넣기
        self.nonSelfMembers = nonSelfMembers
        self.group = group
        self.usersUnreadCountInfo = usersUnreadCountInfo ?? Dictionary(uniqueKeysWithValues: members.map { ($0, 0) } )
        self.latestMessage = latestMessage
    }
}

//MARK: - 채팅방 관련 세부 정보

/// 마지막 채팅 정보
public struct LatestMessageInChat: Hashable, Codable  {
    //public var senderName: String
    public var timestamp: Date?
    public var text: String?
}

public struct FirestoreChatRoom: Codable, Identifiable, Hashable {
    @DocumentID public var id: String?
    public let title: String
    public var group: Bool
    public var members: [String]
    //public var messages: [Message]?
    public var usersUnreadCountInfo: [String: Int]?
    public let latestMessage: FirestoreLastMessage?
}

public struct FirestoreLastMessage: Codable, Hashable {

    @DocumentID public var id: String?
    @ServerTimestamp public var timestamp: Date?
    public var text: String
}

public struct Member: Codable, Hashable {
    var uid: String
    var userName: String
    var profileImageUrl: String?
    
    init(uid: String, userName: String, profileImageUrl: String? = nil) {
        self.uid = uid
        self.userName = userName
        self.profileImageUrl = profileImageUrl
    }
}

struct Message: Identifiable, Hashable {
    var id: String
    
//    static func == (lhs: Message, rhs: Message) -> Bool {
//        lhs.sendMember.uid == rhs.sendMember.uid
//    }
    
    var timestamp: Date
    var imageUrl: String?
    var text: String?
    var sendMember: Member
    
    
    init(id: String, timestamp: Date = Date(), imageUrl: String? = nil, text: String? = nil, sendMember: Member) {
        self.id = id
        self.timestamp = timestamp
        self.imageUrl = imageUrl
        self.text = text
        self.sendMember = sendMember
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


public struct FirestoreMessage: Codable, Hashable {

    @DocumentID public var id: String?
    @ServerTimestamp public var timestamp: Date?
    
    public var userId: String
    public var text: String?
    public var imageUrl: String?
}



// extension ==== 이후 분리

extension Message {
    // 시간 반환
    var time: String {
        DateFormatter.timeFormatter.string(from: timestamp)
    }
    
    var date: String {
        DateFormatter.dateFormatter.string(from: timestamp)
    }
}


// 날짜 변환
extension DateFormatter {
    static let timeFormatter = {
        let formatter = DateFormatter()

        formatter.dateStyle = .none
        formatter.timeStyle = .short

        return formatter
    }()
    static let dateFormatter = {
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy.MM.dd"

        return formatter
    }()

    static func timeString(_ seconds: Int) -> String {
        let hour = Int(seconds) / 3600
        let minute = Int(seconds) / 60 % 60
        let second = Int(seconds) % 60

        if hour > 0 {
            return String(format: "%02i:%02i:%02i", hour, minute, second)
        }
        return String(format: "%02i:%02i", minute, second)
    }
}

