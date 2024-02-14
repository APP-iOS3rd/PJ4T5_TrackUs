//
//  MapViewRepresentable.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/08.
//

import SwiftUI
import MapboxMaps

// 라이브트래킹
struct TrackingMapView: UIViewControllerRepresentable {
    @ObservedObject var mapViewModel: MapViewModel
    
    func makeUIViewController(context: Context) -> UIViewController {
        return Coordinator(mapViewModel: mapViewModel)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapViewModel: mapViewModel)
    }
    
    class Coordinator: UIViewController, GestureManagerDelegate {
        let mapViewModel: MapViewModel
        private var locationTrackingCancellation: AnyCancelable?
        
        init(mapViewModel: MapViewModel) {
            self.mapViewModel = mapViewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            mapViewModel.setupMapView(frame: view.bounds)
            self.view.addSubview(mapViewModel.mapView)
            mapViewModel.mapView.gestures.delegate = self // gesture delegate
        }
        
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
            
        }
    }
}

// 경로를 보여주는 맵뷰
struct RouteMapView: UIViewControllerRepresentable {
    let lineCoordinates: [CLLocationCoordinate2D]
    func makeUIViewController(context: Context) -> UIViewController {
        return Coordinator(lineCoordinates: lineCoordinates)
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(lineCoordinates: lineCoordinates)
    }
    
    class Coordinator: UIViewController, GestureManagerDelegate {
        private var mapView: MapView!
        private let lineCoordinates: [CLLocationCoordinate2D]
        
        init(lineCoordinates: [CLLocationCoordinate2D]) {
            self.lineCoordinates = lineCoordinates
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            var centerPostion = lineCoordinates.first!
            if let updatedCenterPosition = self.calculateCenterCoordinate(for: lineCoordinates) {
                centerPostion = updatedCenterPosition
            }
            let cameraOptions = CameraOptions(center: centerPostion, zoom: 16)
            let myMapInitOptions = MapInitOptions(cameraOptions: cameraOptions)
            self.mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
            self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.mapView.ornaments.options.scaleBar.visibility = .visible
            self.mapView.mapboxMap.styleURI = StyleURI(rawValue: "mapbox://styles/juwon3415/clslhcadg00m301po56lfej03")
            view.addSubview(mapView)
            
            drawRoute()
        }
        
        func drawRoute() {
            var lineAnnotation = PolylineAnnotation(lineCoordinates: lineCoordinates)
            lineAnnotation.lineColor = StyleColor(UIColor.main)
            lineAnnotation.lineWidth = 5
            lineAnnotation.lineJoin = .round
            let lineAnnotationManager = mapView.annotations.makePolylineAnnotationManager()
            lineAnnotationManager.annotations = [lineAnnotation]
            
            let startCoordinate = self.lineCoordinates.first!
            let endCoordinate = self.lineCoordinates.last!
            var startPointAnnotation = PointAnnotation(coordinate: startCoordinate)
            var endPointAnnotation = PointAnnotation(coordinate: endCoordinate)
            startPointAnnotation.image = .init(image: UIImage(named: "StartPin")!, name: "start-pin")
            endPointAnnotation.image = .init(image: UIImage(named: "Puck")!, name: "end-pin")
            let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
            if startCoordinate == endCoordinate {
                pointAnnotationManager.annotations = [startPointAnnotation]
            } else {
                pointAnnotationManager.annotations = [startPointAnnotation, endPointAnnotation]
            }
        }
        
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
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
            
        }
    }
}
