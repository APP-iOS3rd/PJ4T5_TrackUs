//
//  MapViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/08.
//

import SwiftUI
import MapboxMaps
import Combine
import Firebase

class MapViewModel: ObservableObject, Identifiable {
    var mapView: MapView!
    var lineCoordinates = [CLLocationCoordinate2D]()
    private let locationManager = LocationManager.shared
    private let authViewModel = AuthenticationViewModel.shared
    private var locationTrackingCancellation: AnyCancelable?
    private var snapshotter: Snapshotter!
    private var lineAnnotation: PolylineAnnotation!
    private var lineAnnotationManager: PolylineAnnotationManager!
    private var puckConfiguration = Puck2DConfiguration.makeDefault(showBearing: true)
    @Published var timer = Timer.publish(every: 1, on: .main, in: .default)
    @Published var timerHandler: Cancellable?
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var calorie = 0.0
    @Published var elapsedTime = 0.0
    
    // MARK: - 맵뷰 초기설정
    func setupMapView(frame: CGRect) {
        // 초기설정
        locationManager.getCurrentLocation()
        guard let coordinate = locationManager.currentLocation?.coordinate else { return }
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), zoom: 17)
        let myMapInitOptions = MapInitOptions(cameraOptions: cameraOptions)
        self.mapView = MapView(frame: frame, mapInitOptions: myMapInitOptions)
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapView.mapboxMap.styleURI = StyleURI(rawValue: "mapbox://styles/seokki/clslt5i0700m901r64bli645z")
        self.puckConfiguration.topImage = UIImage(named: "Puck")
        self.mapView.location.options.puckType = .puck2D(puckConfiguration)
        self.mapView.location.options.puckBearingEnabled = true
        
        // 경로설정
        self.lineAnnotation = PolylineAnnotation(lineCoordinates: self.lineCoordinates)
        self.lineAnnotationManager = self.mapView.annotations.makePolylineAnnotationManager()
        self.lineAnnotationManager.annotations = [self.lineAnnotation]
        
        // 스냅샷 설정
        let snapshotterOption = MapSnapshotOptions(size: CGSize(width: frame.width, height: frame.height), pixelRatio: UIScreen.main.scale)
        let snapshotterCameraOptions = CameraOptions(cameraState: self.mapView.mapboxMap.cameraState)
        self.snapshotter = Snapshotter(options: snapshotterOption)
        self.snapshotter.setCamera(to: snapshotterCameraOptions)
        self.snapshotter.styleURI = .light
        
        self.lineCoordinates.append(coordinate)
    }
    
    // MARK: - 기록시작
    func startTracking() {
        // 타이머 활성화
        timer = Timer.publish(every: 1, on: .main, in: .default)
        timerHandler = timer.connect()
        
        // 라이브트래킹 옵저브
        self.locationTrackingCancellation = mapView.location.onLocationChange.observe({ [weak mapView] newLocation in
            let coordinateCount = self.lineCoordinates.count
            guard let location = newLocation.last, let mapView else { return }
            if let lastData = self.lineCoordinates.last, lastData == location.coordinate { return}
            // TODO: - lineCoordinates에 비슷하거나 많은 데이터가 들어옴
            
            // 경로선 레이아웃 추가
            self.lineCoordinates.append(location.coordinate)
            self.lineAnnotation = PolylineAnnotation(lineCoordinates: self.lineCoordinates)
            self.lineAnnotation.lineColor = StyleColor(UIColor.main)
            self.lineAnnotation.lineWidth = 5
            self.lineAnnotation.lineJoin = .round
            self.lineAnnotationManager.annotations = [self.lineAnnotation]
            
            // 이동거리 업데이트
            if coordinateCount > 1 {
                self.distance += self.lineAnnotation.lineString.distance(from: self.lineCoordinates[coordinateCount - 2], to: self.lineCoordinates[coordinateCount - 1]) ?? 0
            }
            
            mapView.camera.ease(
                to: CameraOptions(center: location.coordinate, zoom: 17),
                duration: 1.3)
        })
    }
    
    // MARK: - 기록중지
    func stopTracking() {
        timerHandler?.cancel()
        self.locationTrackingCancellation = nil
    }
    
    // MARK: - 운동정보 계산
    @MainActor
    func updateExcerciseData() {
        // 칼로리 계산
        let weightFactor = Double(authViewModel.userInfo.weight ?? 70) * 0.035
        let distanceFactor = self.distance * 0.029
        let durationFactor = self.elapsedTime / 60 * 0.012
        self.calorie = weightFactor + distanceFactor + durationFactor
        
        // 페이스 계산
        self.pace = (self.elapsedTime / 60) / (self.distance / 1000.0)
    }
    
    // MARK: - 운동데이터 업로드
    @MainActor
    func uploadExcerciseData() {
        self.stopTracking()
        let uid = self.authViewModel.userInfo.uid
        // 경로가 여러개 존재하는 경우 카메라 위치 변경
        if let updatedCenterPosition = self.calculateCenterCoordinate(for: self.lineCoordinates) {
            self.snapshotter.setCamera(to: CameraOptions(center: updatedCenterPosition))
        }
        
        // 스크린샷 생성
        snapshotter.start {(overlayHandler) in
            let context = overlayHandler.context
            if self.lineCoordinates.count > 1 {
                self.lineCoordinates.enumerated().forEach { data in
                    guard data.offset > 0 else {
                        context.move(to: overlayHandler.pointForCoordinate(data.element))
                        return
                    }
                    context.addLine(to: overlayHandler.pointForCoordinate(data.element))
                }
            }
            
            context.setStrokeColor(UIColor.main.cgColor)
            context.setLineWidth(5.0)
            context.setLineJoin(.round)
            context.setLineCap(.round)
            context.strokePath()
            
        } completion: {[weak self] result in
            guard case let .success(image) = result, let `self` = self else {
                if case .failure(_) = result {}
                return
            }
            ImageUploader.uploadImage(image: image, type: .map) { url in
                let data: [String : Any] = [
                    "distance": self.distance,
                    "pace": self.pace,
                    "calorie": self.calorie,
                    "elapsedTime": self.elapsedTime,
                    "coordinates": self.lineCoordinates.map {GeoPoint(latitude: $0.latitude, longitude: $0.longitude)},
                    "routeImageUrl": url,
                    "timestamp": Timestamp(date: Date())
                ]
                
                Constants.FirebasePath.COLLECTION_UESRS.document(uid).collection("runningRecords").addDocument(data: data) { error in
                    guard let error = error else { return }
                    print("DEBUG: failed upload Running records data in user collection")
                }
            }
        }
    }
    
    // MARK: - 중앙위치 계산
    func calculateCenterCoordinate(for coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        guard !coordinates.isEmpty else {
            return nil
        }
        
        // 위도와 경도의 평균값 계산
        let totalLatitude = coordinates.map { $0.latitude }.reduce(0, +)
        let totalLongitude = coordinates.map { $0.longitude }.reduce(0, +)
        
        let averageLatitude = totalLatitude / Double(coordinates.count)
        let averageLongitude = totalLongitude / Double(coordinates.count)
        
        return CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
    }
    
}
