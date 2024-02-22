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
    
    func makeUIViewController(context: Context) -> UIViewController {
        return Coordinator()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    final class Coordinator: UIViewController, GestureManagerDelegate {
        internal var mapView: MapView!
        
        init() {
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupMapView()
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
            
            view.addSubview(mapView)
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
            
        }
        
        func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
            
        }
    }
}
