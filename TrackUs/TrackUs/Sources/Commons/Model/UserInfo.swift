//
//  UserInfo.swift
//  TrackUs
//
//  Created by 최주원 on 2/7/24.
//

import Foundation

struct UserInfo : Decodable {
    
    var uid: String
    var username: String
    var weight: Int?
    var height: Int?
    var age: Int?
    var gender: Bool?
    var isProfilePublic: Bool
    var isProSubscriber: Bool
    var profileImageUrl: String?
    var setDailyGoal: Double?
    var runningOption: String?
    
    init(){
        self.uid = ""
        self.username = ""
        self.isProfilePublic = false
        self.isProSubscriber = false
    }
    
    enum CodingKeys:String, CodingKey {
        case uid = "uid"
        case username = "username"
        case weight = "weight"
        case height = "height"
        case age = "age"
        case gender = "gender"
        case isProfilePublic = "isProfilePublic"
        case isProSubscriber = "isProSubscriber"
        case profileImageUrl = "profileImageUrl"
        case setDailyGoal = "setDailyGoal"
        case runningOption = "runningOption"
    }
}
