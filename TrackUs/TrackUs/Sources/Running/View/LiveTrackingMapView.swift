//
//  LiveTrackingMapView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/08.
//

import SwiftUI
import MapboxMaps

// 라이브 러닝맵뷰
struct LiveTrackingMapView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> LiveTrackingMapViewController {
        return LiveTrackingMapViewController()
    }
    
    func updateUIViewController(_ uiViewController: LiveTrackingMapViewController, context: Context) {
    }
}

class LiveTrackingMapViewController: UIViewController, GestureManagerDelegate {
    internal var mapView: MapView!
    private var locationTrackingCancellation: AnyCancelable?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // 맵뷰 초기설정 & 레이아웃 설정
        mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.mapboxMap.styleURI = .light
        self.view.addSubview(mapView)
        mapView.location.options.puckType = .puck2D()
        mapView.location.options.puckBearingEnabled = true
        mapView.gestures.delegate = self // gesture delegate
        
        // 트래킹 시작
        //        startTracking()
    }
    
    // 트래킹 시작
    private func startTracking() {
        locationTrackingCancellation = mapView.location.onLocationChange.observe({ [weak mapView] newLocation in
            guard let location = newLocation.last, let mapView else { return }
            
            mapView.camera.ease(
                to: CameraOptions(center: location.coordinate, zoom: 17, bearing: 0),
                duration: 1.5)
        })
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
        
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
        
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
        
    }
}


