//
//  FirestoreMessage.swift
//  TrackUs
//
//  Created by 최주원 on 2/23/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct FirestoreMessage: Codable, Hashable {

    @DocumentID public var id: String?
    //public var userId: String
    @ServerTimestamp public var timestemp: Date?

    public var text: String
}

// 컬랙션 명칭
struct Collection {
    static let users = "users"
    static let conversations = "conversations"
    static let messages = "messages"
}
