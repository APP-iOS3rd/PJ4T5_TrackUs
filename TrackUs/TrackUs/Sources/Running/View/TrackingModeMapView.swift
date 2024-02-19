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
    
    func makeUIViewController(context: Context) -> UIViewController {
        return Coordinator(router: router)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(router: router)
    }
}

extension TrackingModeMapView {
    class Coordinator: UIViewController, GestureManagerDelegate {
        private let router: Router
        private var mapView: MapView!
        private let locationManager = LocationManager.shared
        private let trackingViewModel = TrackingViewModel()
        private var locationTrackingCancellation: AnyCancelable?
        private var cancellation = Set<AnyCancelable>()
        private var lineAnnotation: PolylineAnnotation!
        private var lineAnnotationManager: PolylineAnnotationManager!
        private var puckConfiguration = Puck2DConfiguration.makeDefault(showBearing: true)
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
        
        
        init(router: Router) {
            self.router = router
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
            let boldFont = UIFont.boldSystemFont(ofSize: 16.0)
            self.countLabel.font = UIFont.italicSystemFont(ofSize: 128.0)
            self.countLabel.textColor = .white
            self.countTextLabel.text = "잠시후 러닝이 시작됩니다!"
            self.countTextLabel.textColor = .white
            self.countTextLabel.font = boldFont
            
            // Button & Button Controller
            let buttonWidth = 85.0
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
            
            self.pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
            self.stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
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
            let distanceToNowLabel = UILabel()
            let distanceToNowImage = UIImageView(image: UIImage(named: "Shose"))
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
            let calorieStackCircle = UIStackView()
            let paceStackCircle = UIStackView()
            let timeStackCircle = UIStackView()
            
            self.excerciesStatusView.translatesAutoresizingMaskIntoConstraints = false
            self.excerciesStatusView.axis = .horizontal
            self.excerciesStatusView.distribution = .equalSpacing
            
            let circleWidth = 85.0
            calorieStackCircle.translatesAutoresizingMaskIntoConstraints = false
            calorieStackCircle.axis = .vertical
            calorieStackCircle.alignment = .center
            calorieStackCircle.backgroundColor = .white
            calorieStackCircle.layer.cornerRadius = circleWidth / 2.0
            calorieStackCircle.clipsToBounds = true
            calorieStackCircle.widthAnchor.constraint(equalToConstant: circleWidth).isActive = true
            calorieStackCircle.heightAnchor.constraint(equalToConstant: circleWidth).isActive = true
            
            
            paceStackCircle.translatesAutoresizingMaskIntoConstraints = false
            paceStackCircle.axis = .vertical
            paceStackCircle.alignment = .center
            paceStackCircle.backgroundColor = .white
            paceStackCircle.layer.cornerRadius = circleWidth / 2
            paceStackCircle.clipsToBounds = true
            paceStackCircle.widthAnchor.constraint(equalToConstant: circleWidth).isActive = true
            paceStackCircle.heightAnchor.constraint(equalTo: paceStackCircle.widthAnchor).isActive = true
            
            timeStackCircle.translatesAutoresizingMaskIntoConstraints = false
            timeStackCircle.axis = .vertical
            timeStackCircle.alignment = .center
            timeStackCircle.backgroundColor = .white
            timeStackCircle.layer.cornerRadius = circleWidth / 2.0
            timeStackCircle.clipsToBounds = true
            timeStackCircle.widthAnchor.constraint(equalToConstant: circleWidth).isActive = true
            timeStackCircle.heightAnchor.constraint(equalToConstant: circleWidth).isActive = true
            
            let fireImage = UIImageView(image: UIImage(named: "Fire"))
            let paceImage = UIImageView(image: UIImage(named: "Pace"))
            let timeImage = UIImageView(image: UIImage(named: "Time"))
            
            let calorieTextLabel = UILabel()
            let paceTextLabel = UILabel()
            let timeTextLabel = UILabel()
            
            calorieTextLabel.text = "소모 칼로리"
            paceTextLabel.text = "페이스"
            timeTextLabel.text = "경과시간"
            
            self.calorieLable.text = "0.0"
            self.paceLabel.text = "-'--''"
            self.timeLabel.text = "00:00"
            
            calorieStackCircle.backgroundColor = .white
            paceStackCircle.backgroundColor = .white
            timeStackCircle.backgroundColor = .white
            
            [fireImage, calorieTextLabel, calorieLable].forEach { calorieStackCircle.addArrangedSubview($0) }
            [paceImage, paceTextLabel, paceLabel].forEach { paceStackCircle.addArrangedSubview($0) }
            [timeImage, timeTextLabel, timeLabel].forEach { timeStackCircle.addArrangedSubview($0) }
            [calorieStackCircle, paceStackCircle, timeStackCircle].forEach { excerciesStatusView.addArrangedSubview($0) }
            
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
                self.countTextLabel.topAnchor.constraint(equalTo: self.countLabel.lastBaselineAnchor, constant: 10),
                
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
            
            // 경로가 이동될때마다
            self.trackingViewModel.$coordinates.sink { [weak self] coordinate in
                guard let self = self else { return }
                self.drawLine()
            }.store(in: &cancellation)
            
            self.trackingViewModel.$distance.sink { [weak self] distance in
                guard let self = self else { return }
                self.kilometerLabel.text = String(format: "%.2fkm/-", distance)
            }.store(in: &cancellation)
        }
        
        // 맵뷰에 경로선 그리는 함수
        private func drawLine() {
            self.lineAnnotation = PolylineAnnotation(lineCoordinates: self.trackingViewModel.coordinates)
            self.lineAnnotationManager.annotations = [self.lineAnnotation]
        }
        
        // 카운트다운 종료시
        private func updatedOnStart() {
            self.countLabel.removeFromSuperview()
            self.countTextLabel.removeFromSuperview()
            self.overlayView.isHidden = true
            self.kilometerStatusView.isHidden = false
            self.excerciesStatusView.isHidden = false
            self.startTracking()
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
                self.trackingViewModel.updateCoordinates(with: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                mapView.camera.ease(
                    to: CameraOptions(center: location.coordinate, zoom: 15),
                    duration: 1.3)
            }
        }
        
        // 트래킹 종료
        private func stopTracking() {
            locationTrackingCancellation?.cancel()
        }
        
        // 일시중지 버튼이 눌렸을때
        @objc func pauseButtonTapped() {
            self.trackingViewModel.isPause = true
        }
        
        // 플레이 버튼이 눌렸을때
        @objc func playButtonTapped() {
            self.trackingViewModel.isPause = false
        }
        
        // 중지 버튼이 눌렸을때
        @objc func stopButtonTapped() {
            self.cancellation.forEach { cancelable in
                cancelable.cancel()
            }
            router.push(.runningResult)
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
            
        }
    }
}
