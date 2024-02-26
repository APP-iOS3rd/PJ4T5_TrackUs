//
//  TrackingModeMapView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/20.
//

import SwiftUI
import MapboxMaps

struct TrackingModeMapView: UIViewControllerRepresentable {
    @ObservedObject var router: Router
    @ObservedObject var trackingViewModel: TrackingViewModel
    
    func makeUIViewController(context: Context) -> UIViewController {
        return Coordinator(router: router, trackingViewModel: trackingViewModel)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(router: router, trackingViewModel: trackingViewModel)
    }
}

extension TrackingModeMapView {
    class Coordinator: UIViewController, GestureManagerDelegate {
        private let router: Router
        private var mapView: MapView!
        private let locationManager = LocationManager.shared
        private let trackingViewModel: TrackingViewModel
        private var locationTrackingCancellation: AnyCancelable?
        private var cancellation = Set<AnyCancelable>()
        private var lineAnnotation: PolylineAnnotation!
        private var lineAnnotationManager: PolylineAnnotationManager!
        private var puckConfiguration = Puck2DConfiguration.makeDefault(showBearing: true)
        private var snapshotter: Snapshotter!
        private let countLabel = UILabel()
        private let countTextLabel = UILabel()
        private let kilometerLabel = UILabel()
        private let calorieLable = UILabel()
        private let paceLabel = UILabel()
        private let timeLabel = UILabel()
        private let overlayView = UIView()
        private let pauseButton = UIButton(type: .system)
        private let stopButton = UIButton(type: .system)
        private let playButton = UIButton(type: .system)
        private var buttonStackView = UIStackView()
        private var kilometerStatusView = UIStackView()
        private let excerciesStatusView = UIStackView()
        
        init(router: Router, trackingViewModel: TrackingViewModel) {
            self.router = router
            self.trackingViewModel = trackingViewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            setupCamera()
            setupUI()
            bind()
            trackingViewModel.initTimer()
        }
        
        // 맵뷰 설정 & 초기 카메라 셋팅
        private func setupCamera() {
            /// 초기위치 및 카메라
            guard let location = locationManager.currentLocation?.coordinate else { return }
            
            let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoom: 16)
            let options = MapInitOptions(cameraOptions: cameraOptions)
            self.mapView = MapView(frame: view.bounds, mapInitOptions: options)
            self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(mapView)
            
            /// 맵뷰 기본설정
            self.mapView.location.options.puckType = .puck2D()
            self.mapView.location.options.puckBearingEnabled = true
            self.mapView.gestures.delegate = self
            self.mapView.mapboxMap.styleURI = .init(rawValue: "mapbox://styles/seokki/clslt5i0700m901r64bli645z")
            self.puckConfiguration.topImage = UIImage(named: "Puck")
            self.mapView.location.options.puckType = .puck2D(puckConfiguration)
            
            /// 경로선
            self.lineAnnotation = PolylineAnnotation(lineCoordinates: [])
            self.lineAnnotationManager = self.mapView.annotations.makePolylineAnnotationManager()
            self.lineAnnotationManager.annotations = [self.lineAnnotation]
            
            /// 스냅셔터
            let snapshotterOption = MapSnapshotOptions(size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height) , pixelRatio: UIScreen.main.scale)
            let snapshotterCameraOptions = CameraOptions(cameraState: self.mapView.mapboxMap.cameraState)
            self.snapshotter = Snapshotter(options: snapshotterOption)
            self.snapshotter.setCamera(to: snapshotterCameraOptions)
            self.snapshotter.styleURI = .init(rawValue: "mapbox://styles/seokki/clslt5i0700m901r64bli645z")
        }
        
        // UI 설정
        private func setupUI() {
            self.countLabel.translatesAutoresizingMaskIntoConstraints = false
            self.countTextLabel.translatesAutoresizingMaskIntoConstraints = false
            self.overlayView.translatesAutoresizingMaskIntoConstraints = false
            self.pauseButton.translatesAutoresizingMaskIntoConstraints = false
            self.stopButton.translatesAutoresizingMaskIntoConstraints = false
            self.playButton.translatesAutoresizingMaskIntoConstraints = false
            self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
            self.kilometerStatusView.translatesAutoresizingMaskIntoConstraints = false
            
            // Label
            if let descriptor = UIFont.systemFont(ofSize: 128.0, weight: .bold).fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
                self.countLabel.font = UIFont(descriptor: descriptor, size: 0)
            } else {
                self.countLabel.font = UIFont.systemFont(ofSize: 128.0, weight: .bold)
            }
            self.countLabel.textColor = .white
            self.countTextLabel.text = "잠시후 러닝이 시작됩니다!"
            self.countTextLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
            self.countTextLabel.textColor = .white
            
            
            // Button & Button Controller
            let buttonWidth = 86.0
            let stopButtonImage = UIImage(systemName: "stop.fill")?.resizeWithWidth(width: 40.0)?.withTintColor(.gray1, renderingMode: .alwaysOriginal)
            let pauseButtonImage = UIImage(systemName: "pause.fill")?.resizeWithWidth(width: 40.0)?.withTintColor(.gray1, renderingMode: .alwaysOriginal)
            let playButtonImage = UIImage(systemName: "play.fill")?.resizeWithWidth(width: 40.0)?.withTintColor(.gray1, renderingMode: .alwaysOriginal)
            
            self.stopButton.setImage(stopButtonImage, for: .normal)
            self.stopButton.backgroundColor = UIColor(white: 0.97, alpha: 1)
            self.stopButton.layer.cornerRadius = buttonWidth / 2
            self.stopButton.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.stopButton.layer.shadowColor = UIColor.black.cgColor
            self.stopButton.layer.shadowOpacity = 0.3
            
            self.playButton.setImage(playButtonImage, for: .normal)
            self.playButton.backgroundColor = UIColor(white: 0.97, alpha: 1)
            self.playButton.layer.cornerRadius = buttonWidth / 2
            self.playButton.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.playButton.layer.shadowColor = UIColor.black.cgColor
            self.playButton.layer.shadowOpacity = 0.3
            
            self.pauseButton.setImage(pauseButtonImage, for: .normal)
            self.pauseButton.backgroundColor = UIColor(white: 0.97, alpha: 1)
            self.pauseButton.layer.cornerRadius = buttonWidth / 2
            self.pauseButton.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.pauseButton.layer.shadowColor = UIColor.black.cgColor
            self.pauseButton.layer.shadowOpacity = 0.3
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stopButtonTapped))
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(stopButtonLongPressed))
            self.stopButton.addGestureRecognizer(tapGesture)
            self.stopButton.addGestureRecognizer(longPressGesture)
            self.pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
            self.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
            
            self.buttonStackView.axis = .horizontal
            self.buttonStackView.distribution = .equalSpacing
            self.buttonStackView.spacing = 16
            self.buttonStackView.isHidden = true
            
            self.overlayView.frame = self.view.bounds
            self.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // Kilometer Status
            self.kilometerStatusView.layer.cornerRadius = 25
            self.kilometerStatusView.backgroundColor = .white
            self.kilometerStatusView.axis = .horizontal
            self.kilometerStatusView.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.kilometerStatusView.layer.shadowColor = UIColor.black.cgColor
            self.kilometerStatusView.layer.shadowOpacity = 0.3
            
            self.kilometerLabel.text = "0.0km"
            self.kilometerLabel.textColor = .gray1
            if let descriptor = UIFont.systemFont(ofSize: 20.0, weight: .bold).fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
                self.kilometerLabel.font = UIFont(descriptor: descriptor, size: 0)
            } else {
                self.kilometerLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
            }
            
            let distanceToNowLabel = UILabel()
            let distanceToNowImage = UIImageView(image: UIImage(named: "Distance"))
            distanceToNowLabel.text = "현재까지 거리"
            distanceToNowLabel.textColor = .gray1
            
            self.kilometerStatusView.alignment = .center
            self.kilometerStatusView.isHidden = true
            self.kilometerStatusView.spacing = 8.0
            
            [distanceToNowImage, distanceToNowLabel, kilometerLabel].forEach { kilometerStatusView.addArrangedSubview($0) }
            
            let spacerView = UIView()
            spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            self.kilometerStatusView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            self.kilometerStatusView.isLayoutMarginsRelativeArrangement = true
            
            self.kilometerStatusView.addArrangedSubview(spacerView)
            self.kilometerStatusView.addArrangedSubview(kilometerLabel)
            self.kilometerStatusView.axis = .horizontal
            
            // Exercise Status
            self.excerciesStatusView.translatesAutoresizingMaskIntoConstraints = false
            self.excerciesStatusView.axis = .horizontal
            self.excerciesStatusView.alignment = .center
            self.excerciesStatusView.distribution = .equalSpacing
            // equalSpacing 본연의 크기대로 설정하되 간격을 동일하게...
            
            
            let calorieStackView = addCircleStackView()
            let paceStackView = addCircleStackView()
            let timeStackView = addCircleStackView()
            
            let fireImage = UIImageView(image: UIImage(named: "Fire"))
            let paceImage = UIImageView(image: UIImage(named: "Pace"))
            let timeImage = UIImageView(image: UIImage(named: "Time"))
            
            let calorieTextLabel = UILabel()
            let paceTextLabel = UILabel()
            let timeTextLabel = UILabel()
            
            calorieTextLabel.text = "소모 칼로리"
            paceTextLabel.text = "페이스"
            timeTextLabel.text = "경과시간"
            
            calorieTextLabel.textColor = .gray1
            paceTextLabel.textColor = .gray1
            timeTextLabel.textColor = .gray1
            self.calorieLable.textColor = .gray1
            self.paceLabel.textColor = .gray1
            self.timeLabel.textColor = .gray1
            
            if let descriptor = UIFont.systemFont(ofSize: 20.0, weight: .bold).fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
                calorieLable.font = UIFont(descriptor: descriptor, size: 0)
                paceLabel.font = UIFont(descriptor: descriptor, size: 0)
                timeLabel.font = UIFont(descriptor: descriptor, size: 0)
            } else {
                calorieLable.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
                paceLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
                timeLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
            }
            
            self.calorieLable.text = "0.0"
            self.paceLabel.text = "-'--''"
            self.timeLabel.text = "00:00"
            
            
            [fireImage, calorieTextLabel, calorieLable].forEach { calorieStackView.addArrangedSubview($0) }
            [paceImage, paceTextLabel, paceLabel].forEach { paceStackView.addArrangedSubview($0) }
            [timeImage, timeTextLabel, timeLabel].forEach { timeStackView.addArrangedSubview($0) }
            [calorieStackView, paceStackView, timeStackView].forEach { excerciesStatusView.addArrangedSubview($0) }
            
            excerciesStatusView.isHidden = true
            
            // Add View's
            self.view.addSubview(overlayView)
            self.view.addSubview(countLabel)
            self.view.addSubview(countTextLabel)
            self.view.addSubview(kilometerStatusView)
            self.view.addSubview(pauseButton)
            self.view.addSubview(buttonStackView)
            self.view.addSubview(excerciesStatusView)
            
            [stopButton, playButton].forEach { self.buttonStackView.addArrangedSubview($0) }
            
            NSLayoutConstraint.activate([
                self.countLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
                self.countLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
                self.countTextLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
                self.countTextLabel.topAnchor.constraint(equalTo: self.countLabel.lastBaselineAnchor, constant: 20),
                
                self.stopButton.widthAnchor.constraint(equalToConstant: buttonWidth),
                self.stopButton.heightAnchor.constraint(equalToConstant: buttonWidth),
                self.playButton.widthAnchor.constraint(equalToConstant: buttonWidth),
                self.playButton.heightAnchor.constraint(equalToConstant: buttonWidth),
                self.pauseButton.widthAnchor.constraint(equalToConstant: buttonWidth),
                self.pauseButton.heightAnchor.constraint(equalToConstant: buttonWidth),
                self.pauseButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
                self.pauseButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
                self.buttonStackView.heightAnchor.constraint(equalToConstant: 90),
                self.buttonStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
                self.buttonStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
                self.buttonStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
                
                self.kilometerStatusView.heightAnchor.constraint(equalToConstant: 53),
                self.kilometerStatusView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
                self.kilometerStatusView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                self.kilometerStatusView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                
                self.excerciesStatusView.heightAnchor.constraint(equalToConstant: 100),
                self.excerciesStatusView.topAnchor.constraint(equalTo: self.kilometerStatusView.bottomAnchor, constant: 20),
                self.excerciesStatusView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                self.excerciesStatusView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            ])
            
        }
        
        // 뷰에 갱신될 값들을 바인딩
        private func bind() {
            // 카운트다운 상태 바인딩
            self.trackingViewModel.$count.sink { [weak self] count in
                guard let self = self else { return }
                self.countLabel.text = "\(count)"
                if count == 0 { updatedOnStart() }
            }.store(in: &cancellation)
            
            // 중지상태 바인딩
            self.trackingViewModel.$isPause.sink { [weak self] isPause in
                guard let self = self else { return }
                isPause ? self.updatedOnPause() : self.updatedOnPlay()
            }.store(in: &cancellation)
            
            self.trackingViewModel.$distance.sink { [weak self] distance in
                guard let self = self else { return }
                
                self.kilometerLabel.text = "\(distance.asString(unit: .kilometer))/\(trackingViewModel.goalDistance.asString(unit: .kilometer))"
            }.store(in: &cancellation)
            
            self.trackingViewModel.$elapsedTime.sink { [weak self] time in
                guard let self = self else { return }
                self.timeLabel.text = time.asString(style: .positional)
            }.store(in: &cancellation)
            
            self.trackingViewModel.$calorie.sink { [weak self] calorie in
                guard let self = self else { return }
                self.calorieLable.text = String(format: "%.1f", calorie)
            }.store(in: &cancellation)
            
            self.trackingViewModel.$pace.sink { [weak self] pace in
                guard let self = self else { return }
                self.paceLabel.text = pace.asString(unit: .pace)
            }.store(in: &cancellation)
        }
        
        // 맵뷰에 경로선 그리는 함수
        private func drawLine() {
            self.lineAnnotation = PolylineAnnotation(lineCoordinates: self.trackingViewModel.coordinates)
            self.lineAnnotation.lineColor = StyleColor(UIColor.main)
            self.lineAnnotation.lineWidth = 5
            self.lineAnnotation.lineJoin = .round
            self.lineAnnotationManager.annotations = [self.lineAnnotation]
        }
        
        // 카운트다운 종료시
        private func updatedOnStart() {
            self.countLabel.removeFromSuperview()
            self.countTextLabel.removeFromSuperview()
            self.overlayView.isHidden = true
            self.kilometerStatusView.isHidden = false
            self.excerciesStatusView.isHidden = false
            self.trackingViewModel.startRecord()
        }
        
        // 일시중지 됬을때
        private func updatedOnPause() {
            self.stopTracking()
            self.overlayView.isHidden = false
            self.pauseButton.isHidden = true
            if trackingViewModel.count == 0 {
                self.buttonStackView.isHidden = false
            }
        }
        
        // 기록중일떄
        private func updatedOnPlay() {
            self.startTracking()
            self.overlayView.isHidden = true
            self.buttonStackView.isHidden = true
            self.pauseButton.isHidden = false
        }
        
        // 트래킹 시작
        private func startTracking() {
            // 맵뷰에서 컴바인 형식으로 새로운 위치를 받아옴(사용자가 이동할떄마다 값을 방출)
            locationTrackingCancellation = mapView.location.onLocationChange.observe { [weak mapView] newLocation in
                // 새로받아온 위치
                guard let location = newLocation.last, let mapView else { return }
                
                self.trackingViewModel.updateCoordinates(with: location.coordinate)
                self.drawLine()
                mapView.camera.ease(
                    to: CameraOptions(center: location.coordinate, zoom: 15),
                    duration: 1.3)
            }
        }
        
        // 트래킹 종료
        private func stopTracking() {
            locationTrackingCancellation?.cancel()
        }
        
        // 스냅샷을 찍기전 위치조정
        private func cameraMoveBeforeCapture(completion: (() -> ())? = nil) {
            // 시작마커 생성
            guard let first = self.trackingViewModel.coordinates.first else { return }
            self.mapView.makeMarkerWithUIImage(coordinate: first, imageName: "StartPin")
            
            
            // 2. 적당한 줌레벨 설정
            // 현재 경로를 기반으로 줌레벨 설정
            let camera = try? self.mapView.mapboxMap.camera(
                for: self.trackingViewModel.coordinates,
                camera: self.mapView.mapboxMap.styleDefaultCamera,
                coordinatesPadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                maxZoom: nil,
                offset: nil
            )
            
            // 3. 카메라 이동(애니메이션 x)
            self.mapView.camera.ease (
                to: camera!,
                duration: 0
            ) { _ in
                    completion?()
            }
        }
        
        // 스냅샵 생성후 저장
        private func takeSnapshotAndProceed() {
            // 맵뷰의 렌더링이 정확히 끝나는 시점을 알기위해 스냅셔터 completion 이용
            // 이미지 캡쳐는 UIKit 내장기능 이용
            snapshotter.start { _ in

            } completion: { _ in
                if let image = UIImage.imageFromView(view: self.mapView) {
                    self.trackingViewModel.snapshot = image
                    self.router.push(.runningResult(self.trackingViewModel))
                }
            }
        }
        
        // 일시중지 버튼이 눌렸을때
        @objc func pauseButtonTapped() {
            self.trackingViewModel.stopRecord()
        }
        
        // 플레이 버튼이 눌렸을때
        @objc func playButtonTapped() {
            self.trackingViewModel.startRecord()
        }
        
        // 중지 버튼이 눌렸을때
        @objc func stopButtonTapped() {
            
        }
        
        // 중지버튼 롱프레스
        @objc func stopButtonLongPressed() {
            cameraMoveBeforeCapture {
                self.takeSnapshotAndProceed()
            }
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
            
        }
        
        func addCircleStackView() -> UIStackView {
            let circleDiameter: CGFloat = 98.0
            let circleView = UIStackView()
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.backgroundColor = .white
            circleView.layer.cornerRadius = circleDiameter / 2.0
            circleView.clipsToBounds = true
            circleView.distribution = .equalSpacing
            circleView.alignment = .center
            circleView.axis = .vertical
            circleView.layoutMargins = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
            circleView.isLayoutMarginsRelativeArrangement = true
            circleView.widthAnchor.constraint(equalToConstant: circleDiameter).isActive = true
            circleView.heightAnchor.constraint(equalToConstant: circleDiameter).isActive = true
            return circleView
        }
    }
}


