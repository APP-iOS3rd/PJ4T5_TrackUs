//
//  PathPreviewMapView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI
import MapboxMaps

// MapStyle
enum MapStyle {
    case standard
    case numberd
}

/**
 러닝경로 프리뷰
 */
struct PathPreviewMap: UIViewControllerRepresentable {
    
    
    var mapStyle: MapStyle = .standard
    var isUserInteractionEnabled: Bool = true
    let coordinates: [CLLocationCoordinate2D]
    
    func makeUIViewController(context: Context) -> UIViewController {
        return PathPreviewMapViewController(coordinates: coordinates, mapStyle: mapStyle, isUserInteractionEnabled: isUserInteractionEnabled)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> PathPreviewMapViewController {
        return PathPreviewMapViewController(coordinates: coordinates, mapStyle: mapStyle, isUserInteractionEnabled: isUserInteractionEnabled)
    }
    
}

// MARK: - Init ViewController
final class PathPreviewMapViewController: UIViewController, GestureManagerDelegate {
    private var mapView: MapView!
    private var  mapStyle: MapStyle = .standard
    private let coordinates: [CLLocationCoordinate2D]
    private let isUserInteractionEnabled: Bool
    
    init(coordinates: [CLLocationCoordinate2D], mapStyle: MapStyle = .standard, isUserInteractionEnabled: Bool) {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.mapStyle = mapStyle
        self.coordinates = coordinates
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupMapType()
        setBoundsOnCenter()
        
    }

    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
        
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
        
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
        
    }
}

// MARK: - UI Method
extension PathPreviewMapViewController {
    /// 맵뷰 스타일 설정
    private func setupMapType() {
        switch self.mapStyle {
        case .standard:
            drawRouteOnlyLine()
        case .numberd:
            drawRouteWithNumberdTruns()
        }
    }
    
    /// 맵뷰 초기화
    private func setupCamera() {
        guard let centerPosition = self.coordinates.calculateCenterCoordinate() else {
            return
        }
        // TODO: - 줌레벨을 거리에 따라서 설정하도록 구현하기
        let cameraOptions = CameraOptions(center: centerPosition, zoom: 12)
        let options = MapInitOptions(cameraOptions: cameraOptions)
        self.mapView = MapView(frame: view.bounds, mapInitOptions: options)
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapView.gestures.delegate = self
        self.mapView.mapboxMap.styleURI = .init(rawValue: "mapbox://styles/seokki/clslt5i0700m901r64bli645z")
        self.mapView.ornaments.options.scaleBar.visibility = .hidden
        self.mapView.ornaments.options.compass = .init(visibility: .hidden)
        self.mapView.isUserInteractionEnabled = isUserInteractionEnabled
        
        view.addSubview(mapView)
    }
    
    /// 경로그려주기
    private func drawRouteOnlyLine() {
        self.drawPath()
        if coordinates.first! == coordinates.last! {
            self.mapView.makeMarkerWithUIImage(coordinate: self.coordinates.first!, imageName: "StartPin")
        } else {
            self.mapView.makeMarkerWithUIImage(coordinate: self.coordinates.first!, imageName: "StartPin")
            self.mapView.makeMarkerWithUIImage(coordinate: self.coordinates.last!, imageName: "Puck")
        }
    }
    
    /// 포인트 찍기
    private func drawRouteWithNumberdTruns() {
        self.drawPath()
        self.coordinates.enumerated().forEach { (offset, value) in
            self.mapView.makeMarkerWithUIImage(coordinate: value, imageName: "point-\(offset +  1)")
        }
    }
    
    /// 경로 그리기
    private func drawPath() {
        var lineAnnotation = PolylineAnnotation(lineCoordinates: coordinates)
        lineAnnotation.lineColor = StyleColor(UIColor.main)
        lineAnnotation.lineWidth = 5
        lineAnnotation.lineJoin = .round
        let lineAnnotationManager = mapView.annotations.makePolylineAnnotationManager()
        lineAnnotationManager.annotations = [lineAnnotation]
    }
    
    /// 경로를 계산한뒤 카메라를 중앙으로 배치하고 줌레벨 설정
    private func setBoundsOnCenter() {
        DispatchQueue.main.async {
            let referenceCamera = CameraOptions(zoom: 5, bearing: 45)
            
            let camera = try? self.mapView.mapboxMap.camera(
                for: self.coordinates,
                camera: referenceCamera,
                coordinatesPadding: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40),
                maxZoom: nil,
                offset: CGPoint(x: 0, y: 40)
            )
            
            self.mapView.camera.ease (
                to: camera!,
                duration: 0
            )
        }
    }
}
