//
//  CourseDrawingMapView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI
import MapboxMaps

/**
 코스를 그려주는 맵뷰 컴포넌트
 */

// MARK: - UIViewController Hosting
struct CourseDrawingMapView: UIViewControllerRepresentable {
    @ObservedObject var courseViewModel: CourseViewModel
    @ObservedObject var router: Router
    
    func makeUIViewController(context: Context) -> UIViewController {
        return CourseDrawingMapViewController(
            courseViewModel: courseViewModel,
            router: router)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> CourseDrawingMapViewController {
        return CourseDrawingMapViewController(
            courseViewModel: courseViewModel,
            router: router)
    }
}

// MARK: - Init ViewController
final class CourseDrawingMapViewController: UIViewController, GestureManagerDelegate {
    internal var mapView: MapView!
    private let courseViewModel: CourseViewModel
    private let router: Router
    private var cancellation = Set<AnyCancelable>()
    private var lineAnnotation: PolylineAnnotation!
    private var lineAnnotationManager: PolylineAnnotationManager!
    private var pointAnnotationManager: PointAnnotationManager!
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("코스 완성", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .main
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "trash"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var revertButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "revert"), for: .normal)
        button.addTarget(self, action: #selector(revertButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(courseViewModel: CourseViewModel, router: Router) {
        self.router = router
        self.courseViewModel = courseViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupUI()
        bind()
    }
    
    
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
        
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
        
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
        
    }
}

// MARK: - UI Methods
extension CourseDrawingMapViewController {
    // 맵뷰 초기화
    private func setupMapView() {
        // 현재위치가 없는경우 정해진 위치(광화문)로 카메라 세팅
        let center = LocationManager.shared.currentLocation?.asCLLocationCoordinate2D() ?? Constants.DEFAULT_LOCATION
        
        let cameraOptions = CameraOptions(center: center, zoom: 17)
        let myMapInitOptions = MapInitOptions(cameraOptions: cameraOptions)
        self.mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapView.ornaments.options.scaleBar.visibility = .hidden
        self.mapView.mapboxMap.styleURI = .init(rawValue: "mapbox://styles/seokki/clslt5i0700m901r64bli645z")
        
        self.lineAnnotation = PolylineAnnotation(lineCoordinates: [])
        self.lineAnnotationManager = self.mapView.annotations.makePolylineAnnotationManager()
        self.lineAnnotationManager.annotations = [self.lineAnnotation]
        
        self.pointAnnotationManager = self.mapView.annotations.makePointAnnotationManager()
        
        view.addSubview(mapView)
    }
    
    private func setupUI() {
        // add view
        [deleteButton, revertButton].forEach { buttonStack.addArrangedSubview($0) }
        
        view.addSubview(completeButton)
        view.addSubview(buttonStack)
        
        // set constraint
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            completeButton.heightAnchor.constraint(equalToConstant: 56),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            self.buttonStack.bottomAnchor.constraint(equalTo: self.completeButton.topAnchor, constant: -20),
            self.buttonStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    // 데이터 바인딩
    private func bind() {
        // 좌표탭 핸들러
        mapView.gestures.onMapTap.observe { context in
            self.courseViewModel.addPath(with: context.coordinate)
        }.store(in: &cancellation)
        
        courseViewModel.$course.sink { [weak self] newValue in
            guard let self = self else { return }
            
            // 데이터 초기화
            cleanUpDataSource()
            
            let coordinates = newValue.courseRoutes.toCLLocationCoordinate2D()
            
            // 마커찍기
            coordinates.enumerated().forEach { (offset, value) in
                self.addMarker(coordinate: value, number: offset)
            }
            
            // 경로 그리기
            self.lineAnnotation = PolylineAnnotation(lineCoordinates: coordinates)
            self.lineAnnotation.lineColor = StyleColor(UIColor.main)
            self.lineAnnotation.lineWidth = 5
            self.lineAnnotation.lineJoin = .round
            self.lineAnnotationManager.annotations = [self.lineAnnotation]
            
        }.store(in: &cancellation)
    }
    
    // 마커추가
    private func addMarker(coordinate: CLLocationCoordinate2D, number: Int) {
        var pointAnnotation = PointAnnotation(coordinate: coordinate)
        pointAnnotation.image = .init(image: UIImage(named: "point-\(number + 1)")!, name: "point-\(number)")
        pointAnnotationManager.annotations.append(pointAnnotation)
    }
    
    // 마커 초기화
    private func cleanUpDataSource() {
        self.pointAnnotationManager.annotations.removeAll()
    }
    
    private func cameraMoveBeforeCapture(completion: (() -> ())? = nil) {
        let camera = try? self.mapView.mapboxMap.camera(
            for: courseViewModel.course.coordinates,
            camera: self.mapView.mapboxMap.styleDefaultCamera,
            coordinatesPadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
            maxZoom: nil,
            offset: nil
        )
        
        self.mapView.camera.ease (
            to: camera!,
            duration: 0
        ) { _ in
            completion?()
        }
    }
}

// MARK: - Objc-C Methods
extension CourseDrawingMapViewController {
    
    @objc func completeButtonTapped() {
        guard courseViewModel.course.coordinates.count >= 2 else {
                       let alert = UIAlertController(title: "알림", message: "경로를 2개 이상 생성해주세요.", preferredStyle: .alert)
                       let confirmAction = UIAlertAction(title: "확인", style: .default)
                       alert.addAction(confirmAction)
                       present(alert, animated: true, completion: nil)
                       return
                   }
        
        cameraMoveBeforeCapture {  [self] in
            if let image = UIImage.imageFromView(view: self.mapView) {
                courseViewModel.uiImage = image
                router.push(.courseRegister(courseViewModel))
            }
            
        }
    }
    
    @objc func deleteButtonTapped() {
        courseViewModel.removePath()
    }
    
    @objc func revertButtonTapped() {
        courseViewModel.revertPath()
    }
}
