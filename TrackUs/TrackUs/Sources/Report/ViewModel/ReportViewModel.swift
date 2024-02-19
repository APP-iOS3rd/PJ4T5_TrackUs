//
//  ReportViewModel.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

//struct Runninglog : Hashable {
//    var calorie: Double
//    var distance: Double
//    var elapsedTime: Int
//    var pace: Double
//    var timestamp: Date
//}

// 임시로 만들어놓은 데이터 하나로 합쳐야 함
struct Runninglog : Hashable {
    var documentID: String? // 추가 문서ID
    var calorie: Double
    var distance: Double
//    var elapsedTime: Int
    var elapsedTime: Double
    var pace: Double
    var timestamp: Date
    var address: String?
//    var coordinates: [GeoPoint]? = []
    var coordinates: [GeoPoint]?
    var routeImageUrl: String?
    var title: String?
}

class ReportViewModel : ObservableObject {
    enum LoadingState {
        case loading
        case loaded
        case error(String)
    }
    
    static let shared = ReportViewModel()
    
    @Published var runningLog = [Runninglog]()
//    @Published var runningLog = [UserRunningLog]()
    @Published var allUserRunningLog = [Runninglog]()
    @Published var userAge: Int = AvgAge.twenties.intValue
    
    @Published var userLogLoadingState = LoadingState.loading // 유저 로그 로딩상태
    
    let db = Firestore.firestore()
    
    
    //MARK: - 로그인한 유저의 러닝 정보 불러오기
    
    func fetchUserLog() {
        // 데이터 로딩 시작
        userLogLoadingState = .loading
        runningLog = []
        
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            print("error uid is nil")
            return
        }
        
//        let db = Firestore.firestore()
        db.collection("users").document(uid).collection("runningRecords").getDocuments() { (snapshot, error) in
            if let error = error {
                print("error fetching runningRecords: \(error.localizedDescription)")
                return
            }
            
//            for runningData in snapshot!.documents {
//                if let calorie = runningData.data()["calorie"] as? Double,
//                   let distance = runningData.data()["distance"] as? Double,
//                   let elapsedTime = runningData.data()["elapsedTime"] as? Int,
//                   let pace = runningData.data()["pace"] as? Double,
//                   let timestamp = runningData.data()["timestamp"] as? Timestamp {
//                    let dateValue = timestamp.dateValue()
//                    let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue)
//                    self.runningLog.append(log)
//
//                }
//            }
            
//            // 2번쨰
//            for runningData in snapshot!.documents {
//                if let calorie = runningData.data()["calorie"] as? Double,
//                   let distance = runningData.data()["distance"] as? Double,
//                   let elapsedTime = runningData.data()["elapsedTime"] as? Int,
//                   let pace = runningData.data()["pace"] as? Double,
//                   let timestamp = runningData.data()["timestamp"] as? Timestamp,
//                   let address = runningData.data()["address"] as? String,
//                   let coordinates = runningData.data()["coordinates"] as? [GeoPoint],
//                   let routeImageUrl = runningData.data()["routeImageUrl"] as? String,
//                   let title = runningData.data()["title"] as? String {
//                    let dateValue = timestamp.dateValue()
//                    let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue, address: address, coordinates: coordinates, routeImageUrl: routeImageUrl, title: title)
//                    self.runningLog.append(log)
//                }
//            }
            
            //3번째
            for runningData in snapshot!.documents {
                let documentID = runningData.documentID // 추가 문서 ID
                if let calorie = runningData.data()["calorie"] as? Double,
                   let distance = runningData.data()["distance"] as? Double,
                   let elapsedTime = runningData.data()["elapsedTime"] as? Double,
                   let pace = runningData.data()["pace"] as? Double,
                   let timestamp = runningData.data()["timestamp"] as? Timestamp {
                    let dateValue = timestamp.dateValue()
                    
                    // title과 address 필드의 값을 읽어옵니다. 값이 없는 경우 nil 처리.
                    let title = runningData.data()["title"] as? String
                    let address = runningData.data()["address"] as? String
                    let routeImageUrl = runningData.data()["routeImageUrl"] as? String
                    let coordinates = runningData.data()["coordinates"] as? [GeoPoint]
                    
//                    let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue, address: address, coordinates: coordinates, routeImageUrl: routeImageUrl, title: title)
                    let log = Runninglog(documentID: documentID, calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue, address: address, coordinates: coordinates, routeImageUrl: routeImageUrl, title: title)
                    
                    if !self.runningLog.contains(log) {
                        self.runningLog.append(log)
                    }
//                    self.runningLog.append(log)
                }
            }
            
            self.runningLog.sort { $0.timestamp > $1.timestamp }
            
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
                    
//                    for runningData in snapshot!.documents {
//                        if let calorie = runningData.data()["calorie"] as? Double,
//                           let distance = runningData.data()["distance"] as? Double,
//                           let elapsedTime = runningData.data()["elapsedTime"] as? Int,
//                           let pace = runningData.data()["pace"] as? Double,
//                           let timestamp = runningData.data()["timestamp"] as? Timestamp {
//                            let dateValue = timestamp.dateValue()
//                            let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue)
//                            self.allUserRunningLog.append(log)
//                            
//                        }
//                    }
                    
//                    for runningData in snapshot!.documents {
//                        if let calorie = runningData.data()["calorie"] as? Double,
//                           let distance = runningData.data()["distance"] as? Double,
//                           let elapsedTime = runningData.data()["elapsedTime"] as? Int,
//                           let pace = runningData.data()["pace"] as? Double,
//                           let timestamp = runningData.data()["timestamp"] as? Timestamp,
//                           let address = runningData.data()["address"] as? String,
//                           let coordinates = runningData.data()["coordinates"] as? [GeoPoint],
//                           let routeImageUrl = runningData.data()["routeImageUrl"] as? String,
//                           let title = runningData.data()["title"] as? String {
//                            let dateValue = timestamp.dateValue()
//                            let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue, address: address, coordinates: coordinates, routeImageUrl: routeImageUrl, title: title)
//                            self.allUserRunningLog.append(log)
//                        }
//                    }
                    
                    //3번째
                    for runningData in snapshot!.documents {
                        if let calorie = runningData.data()["calorie"] as? Double,
                           let distance = runningData.data()["distance"] as? Double,
                           let elapsedTime = runningData.data()["elapsedTime"] as? Double,
                           let pace = runningData.data()["pace"] as? Double,
                           let timestamp = runningData.data()["timestamp"] as? Timestamp {
                            let dateValue = timestamp.dateValue()
                            
                            // title과 address 필드의 값을 읽어옵니다. 값이 없는 경우 nil로 처리.
                            let title = runningData.data()["title"] as? String
                            let address = runningData.data()["address"] as? String
                            let routeImageUrl = runningData.data()["routeImageUrl"] as? String
                            let coordinates = runningData.data()["coordinates"] as? [GeoPoint]
                            
                            let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue, address: address, coordinates: coordinates, routeImageUrl: routeImageUrl, title: title)
                            
                            if !self.allUserRunningLog.contains(log) {
                                self.allUserRunningLog.append(log)
                            }
//                            self.allUserRunningLog.append(log)
                        }
                    }
                    
                    self.allUserRunningLog.sort { $0.timestamp > $1.timestamp }
                    
                    self.userLogLoadingState = .loaded
                }
            }
        }
    }
    
    func deleteRunningLog(_ documentID: String) {
        print("Deleting running log with documentID:", documentID)
        
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            print("error uid is nil")
            return
        }
        
        let docRef = db.collection("users").document(uid).collection("runningRecords").document(documentID)
        docRef.delete() { error in
            if let error = error {
                print("삭제 실패:", error.localizedDescription)
            } else {
                print("삭제 성공")
            }
        }
    }
}

extension GeoPoint {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
