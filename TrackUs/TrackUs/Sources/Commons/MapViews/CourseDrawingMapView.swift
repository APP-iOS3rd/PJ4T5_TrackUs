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
struct CourseDrawingMapView: UIViewControllerRepresentable {
    @ObservedObject var courseRegViewModel: CourseRegViewModel
    @ObservedObject var router: Router
    
    func makeUIViewController(context: Context) -> UIViewController {
        return Coordinator(courseRegViewMoel: courseRegViewModel, router: router)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(courseRegViewMoel: courseRegViewModel, router: router)
    }
    
    final class Coordinator: UIViewController, GestureManagerDelegate {
        internal var mapView: MapView!
        private let courseRegViewModel: CourseRegViewModel
        private let router: Router
        private var cancellation = Set<AnyCancelable>()
        private var lineAnnotation: PolylineAnnotation!
        private var lineAnnotationManager: PolylineAnnotationManager!
        private var pointAnnotationManager: PointAnnotationManager!
        
        // UI
        lazy var buttonStack: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.spacing = 12
            return stack
        }()
        
        lazy var completeButton: UIButton = {
            let button = UIButton()
            button.setTitle("코스 완성", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .main
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 28
            
            return button
        }()
        
        lazy var deleteButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "trash"), for: .normal)
            return button
        }()
        
        lazy var revertButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "revert"), for: .normal)
            return button
        }()
        
        init(courseRegViewMoel: CourseRegViewModel, router: Router) {
            self.router = router
            self.courseRegViewModel = courseRegViewMoel
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
            completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
            deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
            revertButton.addTarget(self, action: #selector(revertButtonTapped), for: .touchUpInside)
            
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
        func bind() {
            // 좌표탭 핸들러
            self.mapView.gestures.onMapTap.observe { context in
                self.courseRegViewModel.addPath(with: context.coordinate)
            }.store(in: &cancellation)
            
            // 코스추가
            self.courseRegViewModel.$coorinates.sink { [weak self] coordinate in
                guard let self = self else { return }
                // 데이터소스 초기화
                cleanUpDataSource()
                
                // 마커찍기
                coordinate.forEach {
                    self.addMarker(coordinate: $0)
                }
                
                // 경로 그리기
                self.lineAnnotation = PolylineAnnotation(lineCoordinates: coordinate)
                self.lineAnnotation.lineColor = StyleColor(UIColor.main)
                self.lineAnnotation.lineWidth = 5
                self.lineAnnotation.lineJoin = .round
                self.lineAnnotationManager.annotations = [self.lineAnnotation]
            }.store(in: &cancellation)
        }
        
        // 마커추가
        private func addMarker(coordinate: CLLocationCoordinate2D) {
            var pointAnnotation = PointAnnotation(coordinate: coordinate)
            pointAnnotation.image = .init(image: UIImage(named: "Puck")!, name: "Puck")
            pointAnnotationManager.annotations.append(pointAnnotation)
        }
        
        // 마커 초기화
        private func cleanUpDataSource() {
            self.pointAnnotationManager.annotations.removeAll()
        }
        
        @objc func completeButtonTapped() {
            guard courseRegViewModel.coorinates.count >= 2 else {
                let alert = UIAlertController(title: "알림", message: "경로를 2개 이상 생성해주세요.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(confirmAction)
                present(alert, animated: true, completion: nil)
                return
            }
            router.push(.courseRegister(courseRegViewModel))
        }
        
        @objc func deleteButtonTapped() {
            courseRegViewModel.removePath()
        }
        
        @objc func revertButtonTapped() {
            courseRegViewModel.revertPath()
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
            
        }
    }
}
