//
//  UserProfileViewModel.swift
//  TrackUs
//
//  Created by 윤준성 on 2/19/24.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ReportData: Hashable {
    var reportText: String
    var reportMenu: String
    var toUserName: String // 신고 당하는 사람 이름
    var toUserUid: String // 신고 당하는 사람 uid
    var fromUserName : String // 신고하는 사람 이름
}

class UserProfileViewModel: ObservableObject {
    enum LoadingState {
        case loading
        case loaded
        case error(String)
    }
    
    static let shared = UserProfileViewModel()
    
    @Published var otherUserInfo: UserInfo = UserInfo()
    @Published var runningLog = [Runninglog]()
    @Published var userLogLoadingState = LoadingState.loading // 유저 로그 로딩상태
    
    public init() {}

    func getOtherUserInfo(for userId: String) {
        Firestore.firestore().collection("users").document(userId).getDocument { [weak self] (snapshot, error) in
            if let error = error {
                print("Error getting user document: \(error)")
                return
            }
            
            guard let document = snapshot else {
                print("User document not found")
                return
            }
            
            do {
                let userInfo = try document.data(as: UserInfo.self)
                self?.otherUserInfo = userInfo
                if let profileImageUrl = userInfo.profileImageUrl {
                    self?.downloadImageFromStorage(uid: userId, imageUrl: profileImageUrl)
                }
            } catch let error {
                print("Error decoding user document: \(error)")
            }
        }
    }

    func downloadImageFromStorage(uid: String, imageUrl: String) {
        let ref = FirebaseManger.shared.storage.reference(forURL: imageUrl)
        
        ref.getData(maxSize: 1 * 1024 * 1024)  { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else {
                if let imageData = data, let image = UIImage(data: imageData) {
                    self.otherUserInfo.image = image
                } else {
                    print("Failed to convert data to UIImage")
                }
            }
        }
    }
    
    func fetchUserLog(userId: String, completion: @escaping () -> Void) {
        print("데이터 로딩 시작")
        // 데이터 로딩 시작
        userLogLoadingState = .loading
        runningLog = []
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("runningRecords").getDocuments() { (snapshot, error) in
            if let error = error {
                print("error fetching runningRecords: \(error.localizedDescription)")
                return
            }
            
            // 성공적으로 데이터를 가져온 경우
            for runningData in snapshot!.documents {
                let documentID = runningData.documentID // 추가 문서 ID
                if let calorie = runningData.data()["calorie"] as? Double,
                   let distance = runningData.data()["distance"] as? Double,
                   let elapsedTime = runningData.data()["elapsedTime"] as? Double,
                   let pace = runningData.data()["pace"] as? Double,
                   let timestamp = runningData.data()["timestamp"] as? Timestamp {
                    let dateValue = timestamp.dateValue()
                    
                    // 값이 없는 경우 nil 처리.
                    let title = runningData.data()["title"] as? String
                    let address = runningData.data()["address"] as? String
                    let routeImageUrl = runningData.data()["routeImageUrl"] as? String
                    let coordinates = runningData.data()["coordinates"] as? [GeoPoint]
                    let targetDistance = runningData.data()["targetDistance"] as? Double
                    let isGroup = runningData.data()["isGroup"] as? Bool
                    let exprectedTime = runningData.data()["exprectedTime"] as? Double
                    
                    let log = Runninglog(documentID: documentID, calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue, address: address, coordinates: coordinates, routeImageUrl: routeImageUrl, title: title, targetDistance: targetDistance, isGroup: isGroup, exprectedTime: exprectedTime ?? 0)
                    
                    if !self.runningLog.contains(log) {
                        self.runningLog.append(log)
                    }
                }
            }
            
            self.runningLog.sort { $0.timestamp > $1.timestamp }
            
            print("데이터 로딩 끝!")
            
            self.userLogLoadingState = .loaded // 데이터 로드 완료
            
            completion()
        }
    }
    
    //MARK: - 유저 신고
    func addReportData(report: ReportData) {
        let id = UUID().uuidString
        
        let reportData = ["uid" : id,
                          "menu" : report.reportMenu,
                          "text" : report.reportText,
                          "toUser" : report.toUserName,
                          "toUserUid" : report.toUserUid,
                          "fromUser" : report.fromUserName,
                          "timestamp" : Date()
        ] as [String : Any]
        FirebaseManger.shared.firestore.collection("report").document(id)
            .setData(reportData) { error in
                if error != nil {
                    return
                }
                print("success")
            }
    }

}
