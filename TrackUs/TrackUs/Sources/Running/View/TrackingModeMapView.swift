//
//  TrackingModeMapView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/20.
//

import SwiftUI
import MapboxMaps

/**
 라이브트래킹 맵뷰
 */
struct TrackingModeMapView: UIViewControllerRepresentable {
    @ObservedObject var router: Router
    @ObservedObject var trackingViewModel: TrackingViewModel
    
    func makeUIViewController(context: Context) -> UIViewController {
        return TrackingModeMapViewController(
            router: router,
            trackingViewModel: trackingViewModel
        )
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> TrackingModeMapViewController {
        return TrackingModeMapViewController(
            router: router,
            trackingViewModel: trackingViewModel
        )
    }
}


final class TrackingModeMapViewController: UIViewController, GestureManagerDelegate {
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
    
    
    // UI
    private let buttonWidth = 86.0
    
    private lazy var pauseButton: UIButton = {
        let button = makeCircleButton(systemImageName: "pause.fill")
        button.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = makeCircleButton(systemImageName: "play.fill")
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = makeCircleButton(systemImageName: "stop.fill")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stopButtonTapped))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(stopButtonLongPressed))
        button.addGestureRecognizer(tapGesture)
        button.addGestureRecognizer(longPressGesture)
        button.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let descriptor = UIFont.systemFont(ofSize: 128.0, weight: .bold).fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
            label.font = UIFont(descriptor: descriptor, size: 0)
        } else {
            label.font = UIFont.systemFont(ofSize: 128.0, weight: .bold)
        }
        label.textColor = .white
        return label
    }()
    
    private lazy var countTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "잠시후 러닝이 시작됩니다!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = self.view.bounds
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.spacing = 16
        sv.isHidden = true
        return sv
    }()
    
    private lazy var roundedVStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.cornerRadius = 25
        sv.backgroundColor = .white
        sv.axis = .horizontal
        sv.layer.shadowOffset = CGSize(width: -1, height: 1)
        sv.layer.shadowColor = UIColor.black.cgColor
        sv.layer.shadowOpacity = 0.3
        sv.alignment = .center
        sv.isHidden = true
        sv.spacing = 8.0
        sv.axis = .horizontal
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        sv.isLayoutMarginsRelativeArrangement = true
        return sv
    }()
    
    private lazy var kilometerLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0km"
        label.textColor = .gray1
        if let descriptor = UIFont.systemFont(ofSize: 20.0, weight: .bold).fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
            label.font = UIFont(descriptor: descriptor, size: 0)
        } else {
            label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        }
        return label
    }()
    
    private lazy var circleHStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.isHidden = true
        return sv
    }()
    
    private lazy var spacerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private lazy var calorieLable: UILabel = {
        let label = makeBigTextLabel(text: "0.0")
        return label
    }()
    
    private lazy var paceLabel: UILabel = {
        let label = makeBigTextLabel(text: "-'--''")
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = makeBigTextLabel(text: "00:00")
        return label
    }()
    
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
}


// MARK: - Setup UI
extension TrackingModeMapViewController {
    /// UI 설정
    private func setupUI() {
        // setup UI
        let distanceToNowLabel = makeTextLabel(text: "현재까지 거리")
        let distanceToNowImage = UIImageView(image: UIImage(named: "Distance"))
        
        [distanceToNowImage, distanceToNowLabel, kilometerLabel].forEach { roundedVStackView.addArrangedSubview($0) }
        
        self.roundedVStackView.addArrangedSubview(spacerView)
        self.roundedVStackView.addArrangedSubview(kilometerLabel)
        
        let calorieStackView = makeCircleStackView()
        let paceStackView = makeCircleStackView()
        let timeStackView = makeCircleStackView()
        
        let fireImage = UIImageView(image: UIImage(named: "Fire"))
        let paceImage = UIImageView(image: UIImage(named: "Pace"))
        let timeImage = UIImageView(image: UIImage(named: "Time"))
        
        let calorieTextLabel = makeTextLabel(text: "소모 칼로리")
        let paceTextLabel = makeTextLabel(text: "페이스")
        let timeTextLabel = makeTextLabel(text: "경과시간")
        
        
        [fireImage, calorieTextLabel, calorieLable].forEach { calorieStackView.addArrangedSubview($0) }
        [paceImage, paceTextLabel, paceLabel].forEach { paceStackView.addArrangedSubview($0) }
        [timeImage, timeTextLabel, timeLabel].forEach { timeStackView.addArrangedSubview($0) }
        [calorieStackView, paceStackView, timeStackView].forEach { circleHStackView.addArrangedSubview($0) }
        
        // Add View's
        self.view.addSubview(overlayView)
        self.view.addSubview(countLabel)
        self.view.addSubview(countTextLabel)
        self.view.addSubview(roundedVStackView)
        self.view.addSubview(pauseButton)
        self.view.addSubview(buttonStackView)
        self.view.addSubview(circleHStackView)
        
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
            
            self.roundedVStackView.heightAnchor.constraint(equalToConstant: 53),
            self.roundedVStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.roundedVStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.roundedVStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            self.circleHStackView.heightAnchor.constraint(equalToConstant: 100),
            self.circleHStackView.topAnchor.constraint(equalTo: self.roundedVStackView.bottomAnchor, constant: 20),
            self.circleHStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.circleHStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
        
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
        
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
        
    }
}

// MARK: - Interaction with combine
extension TrackingModeMapViewController {
    /// 맵뷰 설정 & 초기 카메라 셋팅
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
    
    
    
    // 뷰에 갱신될 값들을 바인딩
    private func bind() {
        // 카운트다운 상태 바인딩
        self.trackingViewModel.$count.receive(on: DispatchQueue.main).sink { [weak self] count in
            guard let self = self else { return }
            self.countLabel.text = "\(count)"
            if count == 0 { updatedOnStart() }
        }.store(in: &cancellation)
        
        // 중지상태 바인딩
        self.trackingViewModel.$isPause.receive(on: DispatchQueue.main).sink { [weak self] isPause in
            guard let self = self else { return }
            isPause ? self.updatedOnPause() : self.updatedOnPlay()
        }.store(in: &cancellation)
        
        self.trackingViewModel.$distance.receive(on: DispatchQueue.main).sink { [weak self] distance in
            guard let self = self else { return }
            
            self.kilometerLabel.text = "\(distance.asString(unit: .kilometer))/\(trackingViewModel.goalDistance.asString(unit: .kilometer))"
        }.store(in: &cancellation)
        
        self.trackingViewModel.$elapsedTime.receive(on: DispatchQueue.main).receive(on: DispatchQueue.main).sink { [weak self] time in
            guard let self = self else { return }
            self.timeLabel.text = time.asString(style: .positional)
        }.store(in: &cancellation)
        
        self.trackingViewModel.$calorie.receive(on: DispatchQueue.main).sink { [weak self] calorie in
            guard let self = self else { return }
            self.calorieLable.text = String(format: "%.1f", calorie)
        }.store(in: &cancellation)
        
        self.trackingViewModel.$pace.receive(on: DispatchQueue.main).sink { [weak self] pace in
            guard let self = self else { return }
            self.paceLabel.text = pace.asString(unit: .pace)
        }.store(in: &cancellation)
    }
    
    // 카운트다운 종료시
    private func updatedOnStart() {
        self.countLabel.removeFromSuperview()
        self.countTextLabel.removeFromSuperview()
        self.overlayView.isHidden = true
        self.roundedVStackView.isHidden = false
        self.circleHStackView.isHidden = false
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
}

// MARK: - Objc-C Methods
extension TrackingModeMapViewController {
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
}

// MARK: - UI Generator
extension TrackingModeMapViewController {
    
    private func makeCircleStackView() -> UIStackView {
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
    
    private func makeCircleButton(systemImageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let pauseButtonImage = UIImage(systemName: systemImageName)?.resizeWithWidth(width: 40.0)?.withTintColor(.gray1, renderingMode: .alwaysOriginal)
        button.setImage(pauseButtonImage, for: .normal)
        button.backgroundColor = UIColor(white: 0.97, alpha: 1)
        button.layer.cornerRadius = buttonWidth / 2
        button.layer.shadowOffset = CGSize(width: -1, height: 1)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        return button
    }
    
    private func makeTextLabel(text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .gray1
        return label
    }
    
    private func makeBigTextLabel(text: String?) -> UILabel {
        let label = UILabel()
        label.textColor = .gray1
        label.text = text
        if let descriptor = UIFont.systemFont(ofSize: 20.0, weight: .bold).fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
            label.font = UIFont(descriptor: descriptor, size: 0)
            
        } else {
            label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        }
        return label
    }
}
