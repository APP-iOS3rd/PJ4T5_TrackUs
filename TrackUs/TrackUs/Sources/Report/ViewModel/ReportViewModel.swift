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
    var timestamp: Timestamp
}

class ReportViewModel : ObservableObject {
    static let shared = ReportViewModel()
    
    @Published var runningLog = [Runninglog]()
    @Published var isFirestoreConnected = false
    
    func fetchLog() {
        runningLog = []
        
        let db = Firestore.firestore()
        db.collection("runningRecords").getDocuments() { (snapshot, error) in
            if let error = error {
                print("error fetching runningRecords")
                return
            } else {
                print("snapshot1 : \(snapshot)")
                //            }
                
                for document in snapshot!.documents {
                    print("document = \(document)")
                    let userID = document.documentID
                    print("userID = \(userID)")
                    db.collection("runningRecords").document(userID).collection("record").getDocuments() { (snapshot, error) in
                        if let error = error {
                            print("Error fetching record for user \(userID)")
                            return
                        } else {
                            print("snapshot2 : \(snapshot)")
                        }
                        
                        for runningData in snapshot!.documents {
                            if let calorie = runningData.data()["calorie"] as? Double,
                               let distance = runningData.data()["distance"] as? Double,
                               let elapsedTime = runningData.data()["elapsedTime"] as? Int,
                               let pace = runningData.data()["pace"] as? Double,
                               let timestamp = runningData.data()["timestamp"] as? Timestamp {
                                //                            print(calorie, distance, elapsedTime, pace, timestamp)
                                let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: timestamp)
                                self.runningLog.append(log)
                            }
                            //                        print(runningData)
                        }
                    }
                    //                print(document)
                }
                //            print(self.runningLog)
            }
            
            //        print(self.runningLog)
        }
    }
}

//        runningLog = []
        
//        let db = Firestore.firestore()
//        db.collection("runningRecords").getDocuments() { (snapshot, error) in

//                db.collection("runningRecords").document(userID).collection("record").getDocuments() { (snapshot, error) in

//                            let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: timestamp.dateValue())



//        Constants.FirebasePath.RUNNING_RECORDS.getDocuments() { (snapshot, error) in
//                Constants.FirebasePath.RUNNING_RECORDS.document(userID).collection("record").getDocuments() { (snapshot, error) in
