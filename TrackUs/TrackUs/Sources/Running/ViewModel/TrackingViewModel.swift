//
//  TrackingViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/19.
//

import UIKit
import Combine
import SwiftUI
import MapboxMaps
import Firebase

enum NetworkStatus {
    case none
    case loading
    case error
    case success
}
// 위치변화 감지 -> 위치값 저장 -> 저장된 위치값을 경로에 그려주기(뷰컨에서 구독)
class TrackingViewModel: ObservableObject {
    var snapshot: UIImage?
    var groupID = ""
    var goalDistance: Double = 0.0
    
    private let id = UUID()
    private let authViewModel = AuthenticationViewModel.shared
    @Published var count: Int = 3
    @Published var isPause: Bool = true
    @Published var newtworkStatus: NetworkStatus = .none
    @Published var title: String = ""
    @Published var coordinates: [CLLocationCoordinate2D] = []
    @Published var distance: Double = 0.0
    @Published var elapsedTime: Double = 0.0
    @Published var calorie: Double = 0.0
    @Published var pace: Double = 0.0
    @Published var isGroup: Bool = false
    
    private var countTimer: Timer = Timer()
    private var recordTimer: Timer = Timer()
    
    init() {
     
    }
    
    // 카운트다운
    @MainActor
    func initTimer() {
            self.countTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.count -= 1
                    if self.count == 0 {
                        self.countTimer.invalidate()
                    }
                }
            })
    }
    
    // 경로데이터 업데이트 함수
    @MainActor
    func updateCoordinates(with coordinate: CLLocationCoordinate2D) {
            self.coordinates.append(coordinate)
            
            guard self.coordinates.count > 1 else { return }
            
            let newLocation = self.coordinates[self.coordinates.count - 1]
            let oldLocation = self.coordinates[self.coordinates.count - 2]
            
            self.distance += (newLocation.distance(to: oldLocation)) / 1000.0
            self.calorie = ExerciseManager.calculatedCaloriesBurned(distance: self.distance)
            self.pace = ExerciseManager.calculatedPace(distance: self.distance, totalTime: self.elapsedTime)
    }
    
    // 기록시작
    @MainActor
    func startRecord() {
        self.isPause = false
        self.recordTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 1
        })
    }
    
    // 기록중지
    @MainActor
    func stopRecord() {
        self.isPause = true
        self.recordTimer.invalidate()
    }
    
    // 데이터 추가(DB)
    // throw 함수를 만들면서 throw가 되씅때 네트워크상태를 에러로 만들어보기
    @MainActor
    func uploadRecordedData(targetDistance: Double, expectedTime: Double) {
        self.newtworkStatus = .loading 
        let uid = authViewModel.userInfo.uid
    
        guard let image = snapshot else { return }
        ImageUploader.uploadImage(image: image, type: .map) { url in
            let firstCoordinate = self.coordinates.first!
            let coordinate = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
            LocationManager.shared.convertToAddressWith(coordinate: coordinate) { address in
                guard let address = address else { return }
                
                let data: [String : Any] = [
                    "title": self.title == "" ? "\(address) 에서 러닝" : self.title,
                    "distance": self.distance,
                    "pace": self.pace,
                    "calorie": self.calorie,
                    "elapsedTime": self.elapsedTime,
                    "coordinates": self.coordinates.map {GeoPoint(latitude: $0.latitude, longitude: $0.longitude)},
                    "routeImageUrl": url,
                    "address": address,
                    "targetDistance": targetDistance,
                    "exprectedTime": expectedTime * 60,
                    "timestamp": Timestamp(date: Date()),
                    "isGroup": self.isGroup,
                    "groupID": self.groupID
                ]
                
                Constants.FirebasePath.COLLECTION_UESRS.document(uid).collection("runningRecords").addDocument(data: data) { _ in
                    self.newtworkStatus = .success
                }
            }
        }
    }
}

extension TrackingViewModel: Hashable {
    static func == (lhs: TrackingViewModel, rhs: TrackingViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

