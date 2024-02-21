//
//  Double+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/12.
//

import Foundation

enum FormattedStyle {
    case pace
    case kilometer
    case calorie
}

extension Double {
    var radians: Double {
        return self * .pi / 180.0
    }
    
    // 정수를 00:00 형식으로 포매팅
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = style
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? ""
    }
    
    // 러닝페이스 형식으로 포매팅
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
            return String(format: "%.2f km", self)
        case .calorie:
            return String(format: "%.1f kcal", self)
        }
    }
}


