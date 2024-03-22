//
//  TrackingViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/19.
//

import UIKit
import SwiftUI
import MapboxMaps
import Firebase


// 위치변화 감지 -> 위치값 저장 -> 저장된 위치값을 경로에 그려주기(뷰컨에서 구독)
final class TrackingViewModel: ObservableObject {
    enum NetworkError: Error {
        case snapshotError
        case fetchError
    }
    private let id = UUID()
    private let authViewModel = AuthenticationViewModel.shared
    private var countTimer: Timer = Timer()
    private var recordTimer: Timer = Timer()
    
    var snapshot: UIImage?
    var groupID: String?
    var goalDistance: Double = 0.0
    
    @Published var count: Int = 3
    @Published var isPause: Bool = true
    @Published var title: String = ""
    @Published var coordinates: [CLLocationCoordinate2D] = []
    @Published var distance: Double = 0.0
    @Published var elapsedTime: Double = 0.0
    @Published var calorie: Double = 0.0
    @Published var pace: Double = 0.0
    @Published var isGroup: Bool = false
    @Published var isLoading: Bool = false
    
    init(goalDistance: Double, groupID: String? = nil, isGroup: Bool = false) {
        self.goalDistance = goalDistance
        self.groupID = groupID
        self.isGroup = isGroup
    }
}

// MARK: - UI Update 🎨
extension TrackingViewModel {
    /// 카운트다운
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
    
    /// 경로데이터 업데이트 함수
    @MainActor
    func updateCoordinates(with coordinate: CLLocationCoordinate2D) {
            self.coordinates.append(coordinate)
            
            guard self.coordinates.count > 1 else { return }
            
            let newLocation = self.coordinates[self.coordinates.count - 1]
            let oldLocation = self.coordinates[self.coordinates.count - 2]
            
            self.distance += (newLocation.distance(to: oldLocation))
            self.calorie = ExerciseManager.calculatedCaloriesBurned(distance: self.distance)
            self.pace = ExerciseManager.calculatedPace(distance: self.distance, timeInSeconds: self.elapsedTime)
    }
    
    /// 기록시작
    @MainActor
    func startRecord() {
        self.isPause = false
        self.recordTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 1
        })
    }
    
    /// 기록중지
    @MainActor
    func stopRecord() {
        self.isPause = true
        self.recordTimer.invalidate()
    }
}

// MARK: - Network Requests 🌐
extension TrackingViewModel {
    /// 러닝데이터 저장
    @MainActor
    func uploadRunningData() throws {
        let uid = authViewModel.userInfo.uid
        
        self.isLoading = true
        
        guard let image = snapshot else {
            throw TrackingViewModel.NetworkError.snapshotError
        }
        
        ImageUploader.uploadImage(image: image, type: .map) { url in
            
            let firstCoordinate = self.coordinates.first!
            let coordinate = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
            
            LocationManager.shared.convertToAddressWith(coordinate: coordinate) { address in
                
                let data: [String : Any] = [
                    "title": self.title == "" ? "\(address) 에서 러닝" : self.title,
                    "distance": self.distance,
                    "pace": self.pace,
                    "calorie": self.calorie,
                    "elapsedTime": self.elapsedTime,
                    "coordinates": self.coordinates.toGeoPoint(),
                    "targetDistance": self.goalDistance,
                    "isGroup": self.isGroup,
                    "groupID": self.groupID ?? "",
                    "routeImageUrl": url,
                    "address": address,
                    "timestamp": Timestamp(date: Date()),
                ]
                
                Constants.FirebasePath.COLLECTION_UESRS.document(uid).collection("records").addDocument(data: data) { error in
                    self.isLoading = false
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

