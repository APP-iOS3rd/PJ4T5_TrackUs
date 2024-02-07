//
//  MaxBoxMapView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/04.
//

import SwiftUI
import MapboxMaps

struct MapBoxMapView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController()
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
    }
}

class MapViewController: UIViewController, GestureManagerDelegate {
    internal var mapView: MapView!
    private var locationTrackingCancellation: AnyCancelable?
    private let locationManager = LocationManager.shared
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let bounds = CoordinateBounds(
            southwest: CLLocationCoordinate2D(latitude: 33.0, longitude: 124.0),
                northeast: CLLocationCoordinate2D(latitude: 38.0, longitude: 132.0))
        
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: locationManager.currentLocation?.coordinate.latitude ?? 37.57098684878895, longitude: locationManager.currentLocation?.coordinate.longitude ?? 126.97891142355786), zoom: 14, bearing: 0, pitch: 0)
        let cameraBoundsOptions = CameraBoundsOptions(bounds: bounds)
        let myMapInitOptions = MapInitOptions(cameraOptions: cameraOptions)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.mapboxMap.styleURI = .light
        try? mapView.mapboxMap.setCameraBounds(with: cameraBoundsOptions)
        self.view.addSubview(mapView)
        
        mapView.location.options.puckType = .puck2D()
        mapView.gestures.delegate = self // gesture delegate
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
        
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
        
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
        
    }
}
