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
    static let shared = ReportViewModel()
    
    @Published var runningLog = [Runninglog]()
    @Published var allUserRunningLog = [Runninglog]()
    @Published var userAge: Int = AvgAge.twenties.intValue
    
    
//MARK: - 로그인한 유저의 러닝 정보 불러오기
    
    func fetchUserLog() {
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
        }
    }
    
//MARK: - 선택한 연령대 유저들의 러닝 정보 불러오기
    
    func fetchUserAgeLog() {
        allUserRunningLog = []
        
        let db = Firestore.firestore()
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
                }
            }
        }
    }
}

//class ReportViewModel : ObservableObject {
//    static let shared = ReportViewModel()
//    
//    @Published var runningLog = [Runninglog]()
//    @Published var isFirestoreConnected = false
//    
//    func fetchLog() {
//        runningLog = []
//        
//        let db = Firestore.firestore()
//        db.collection("users").getDocuments() { (snapshot, error) in
//            if let error = error {
//                print("error fetching runningRecords")
//                return
//            }
//                
//                for document in snapshot!.documents {
//                    let userID = document.documentID
//                    db.collection("users").document(userID).collection("runningRecords").getDocuments() { (snapshot, error) in
//                        if let error = error {
//                            print("Error fetching record for user \(userID)")
//                            return
//                        }
//                        
//                        for runningData in snapshot!.documents {
//                            if let calorie = runningData.data()["calorie"] as? Double,
//                               let distance = runningData.data()["distance"] as? Double,
//                               let elapsedTime = runningData.data()["elapsedTime"] as? Int,
//                               let pace = runningData.data()["pace"] as? Double,
//                               let timestamp = runningData.data()["timestamp"] as? Timestamp {
//                                let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: timestamp)
//                                self.runningLog.append(log)
//                            }
//                        }
//                    }
//                }
//        }
//    }
//}
