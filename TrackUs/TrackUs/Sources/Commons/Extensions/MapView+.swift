//
//  MapView+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import MapboxMaps
import UIKit

extension MapView {
  
    /// 이미지로 마커를 생성
     func makeMarkerWithUIImage(coordinate: CLLocationCoordinate2D, imageName: String) {
        let pointAnnotationManager = self.annotations.makePointAnnotationManager()
        var pointAnnotation = PointAnnotation(coordinate: coordinate)
        pointAnnotation.image = .init(image: UIImage(named: imageName)!, name: imageName)
        pointAnnotationManager.annotations.append(pointAnnotation)
    }
    
    func removeAllMarkers() {
       let pointAnnotationManager = self.annotations.makePointAnnotationManager()
       pointAnnotationManager.annotations.removeAll()
    }
    
    
}
