//
//  Double+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/12.
//

import Foundation

extension Double {
    /// 포맷팅 스타일
    enum FormattedStyle {
        case pace
        case kilometer
        case calorie
    }
    
    var radians: Double {
        return self * .pi / 180.0
    }
    
    var secondsInHours: Int {
        return Int(self / 3600)
    }
    
    var secondsInMinutes: Int {
        return Int(self) % 3600 / 60
    }
    
    var seconds: Int {
        return Int(self) % 60
    }
    
    /// 시간(sec) -> MM:SS
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = style
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? ""
    }
    
    /// 거리(m) -> 거리(km)
    func asString(unit: FormattedStyle) -> String {
        switch unit {
        case .pace:
            guard self != 0.0 && self != .infinity && !self.isNaN  else { return "-'--''" }
            let formattedString = String(format: "%.3f", self)
            let paceInMinutes = formattedString[formattedString.startIndex]
            let paceInSecondsFirst = formattedString[formattedString.index(formattedString.startIndex, offsetBy: 2)]
            let paceInSecondsThird = formattedString[formattedString.index(formattedString.startIndex, offsetBy: 3)]
            
            return "\(paceInMinutes)'\(paceInSecondsFirst)\(paceInSecondsThird)''"
        case .kilometer:
            return String(format: "%.2f km", self / 1000.0)
        case .calorie:
            return String(format: "%.1f kcal", self)
        }
    }
}


