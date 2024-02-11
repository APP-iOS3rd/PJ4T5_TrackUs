//
//  Double+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/12.
//

import Foundation

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
}
