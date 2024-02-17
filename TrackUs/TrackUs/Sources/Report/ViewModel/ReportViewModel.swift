//
//  ReportViewModel.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Runninglog : Hashable {
    var calorie: Double
    var distance: Double
    var elapsedTime: Int
    var pace: Double
    var timestamp: Date
}

class ReportViewModel : ObservableObject {
    enum LoadingState {
        case loading
        case loaded
        case error(String)
    }
    
    static let shared = ReportViewModel()
    
    @Published var runningLog = [Runninglog]()
    @Published var allUserRunningLog = [Runninglog]()
    @Published var userAge: Int = AvgAge.twenties.intValue
    
    @Published var userLogLoadingState = LoadingState.loading // 유저 로그 로딩상태
    
    
    //MARK: - 로그인한 유저의 러닝 정보 불러오기
    
    func fetchUserLog() {
        // 데이터 로딩 시작
        userLogLoadingState = .loading
        runningLog = []
        
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            print("error uid is nil")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).collection("runningRecords").getDocuments() { (snapshot, error) in
            if let error = error {
                print("error fetching runningRecords: \(error.localizedDescription)")
                return
            }
            
            for runningData in snapshot!.documents {
                if let calorie = runningData.data()["calorie"] as? Double,
                   let distance = runningData.data()["distance"] as? Double,
                   let elapsedTime = runningData.data()["elapsedTime"] as? Int,
                   let pace = runningData.data()["pace"] as? Double,
                   let timestamp = runningData.data()["timestamp"] as? Timestamp {
                    let dateValue = timestamp.dateValue()
                    let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue)
                    self.runningLog.append(log)
                    
                }
            }
            
            self.userLogLoadingState = .loaded // 데이터 로드 완료
        }
    }
    
    //MARK: - 선택한 연령대 유저들의 러닝 정보 불러오기
    
    func fetchUserAgeLog() {
        // 데이터 로딩 시작
        userLogLoadingState = .loading
        
        allUserRunningLog = []
        
        let db = Firestore.firestore()
        print("\(userAge)")
        db.collection("users").whereField("age", isEqualTo: userAge).getDocuments() { (snapshot, error) in
            if let error = error {
                print("error fetching SameAgeUser")
                return
            }
            
            for document in snapshot!.documents {
                let userID = document.documentID
                db.collection("users").document(userID).collection("runningRecords").getDocuments() { (snapshot, error) in
                    if let error = error {
                        print("Error fetching SameAgeUser Running Log")
                        return
                    }
                    
                    for runningData in snapshot!.documents {
                        if let calorie = runningData.data()["calorie"] as? Double,
                           let distance = runningData.data()["distance"] as? Double,
                           let elapsedTime = runningData.data()["elapsedTime"] as? Int,
                           let pace = runningData.data()["pace"] as? Double,
                           let timestamp = runningData.data()["timestamp"] as? Timestamp {
                            let dateValue = timestamp.dateValue()
                            let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue)
                            self.allUserRunningLog.append(log)
                            
                        }
                    }
                    
                    self.userLogLoadingState = .loaded
                }
            }
        }
    }
}
