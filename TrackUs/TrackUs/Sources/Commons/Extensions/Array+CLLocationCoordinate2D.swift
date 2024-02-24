//
//  Array+CLLocationCoordinate2D.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import MapboxMaps

extension Array where Element == CLLocationCoordinate2D {
    /// 위도와 경도의 중간 좌표를 반환합니다.
    func calculateCenterCoordinate() -> CLLocationCoordinate2D? {
        guard !self.isEmpty else {
            return nil
        }
        let totalLatitude = self.map { $0.latitude }.reduce(0, +)
        let totalLongitude = self.map { $0.longitude }.reduce(0, +)
        
        let averageLatitude = totalLatitude / Double(self.count)
        let averageLongitude = totalLongitude / Double(self.count)
        return CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
    }
    
    func getTotalDistanceBetweenPoints() -> Double {
        return 0
    }
}
