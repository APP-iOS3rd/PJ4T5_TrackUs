//
//  PathPreviewMapView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI
import MapboxMaps

/**
 러닝경로 프리뷰
 */
struct PathPreviewMap: UIViewControllerRepresentable {
    enum MapStyle {
        /// 시작, 도착지점에만 마커 표시
        case standard
        
        /// 포인트마다 숫자 표시
        case numberd
    }
    
    let coordinates: [CLLocationCoordinate2D]
    var mapStyle: PathPreviewMap.MapStyle = .standard
    
    func makeUIViewController(context: Context) -> UIViewController {
        return Coordinator(coordinates: coordinates, mapStyle: mapStyle)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(coordinates: coordinates, mapStyle: mapStyle)
    }
    
    final class Coordinator: UIViewController, GestureManagerDelegate {
        private var mapView: MapView!
        private var  mapStyle: PathPreviewMap.MapStyle = .standard
        private let coordinates: [CLLocationCoordinate2D]
        
        init(coordinates: [CLLocationCoordinate2D], mapStyle: MapStyle = .standard) {
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
        
        // 맵뷰 스타일 설정
        private func setupMapType() {
            switch self.mapStyle {
            case .standard:
                drawRouteOnlyLine()
            case .numberd:
                drawRouteWithNumberdTruns()
            }
        }
        
        // 맵뷰 초기화
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
            view.addSubview(mapView)
        }
        
        // 경로그려주기
        private func drawRouteOnlyLine() {
            self.drawPath()
            if coordinates.first! == coordinates.last! {
                self.mapView.makeMarkerWithUIImage(coordinate: self.coordinates.first!, imageName: "StartPin")
            } else {
                self.mapView.makeMarkerWithUIImage(coordinate: self.coordinates.first!, imageName: "StartPin")
                self.mapView.makeMarkerWithUIImage(coordinate: self.coordinates.last!, imageName: "Puck")
            }
        }
        
        private func drawRouteWithNumberdTruns() {
            self.drawPath()
        }
        
        // 경로 그리기
        private func drawPath() {
            var lineAnnotation = PolylineAnnotation(lineCoordinates: coordinates)
            lineAnnotation.lineColor = StyleColor(UIColor.main)
            lineAnnotation.lineWidth = 5
            lineAnnotation.lineJoin = .round
            let lineAnnotationManager = mapView.annotations.makePolylineAnnotationManager()
            lineAnnotationManager.annotations = [lineAnnotation]
        }
        
        // 경로를 계산한뒤 카메라를 중앙으로 배치하고 줌레벨 설정
        private func setBoundsOnCenter() {
            // 지도가 렌더링된 후에 업데이트 하기위해 실행지연
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
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
            
        }
    }
}
