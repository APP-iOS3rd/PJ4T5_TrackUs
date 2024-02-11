//
//  Double+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/12.
//

import Foundation

extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
          formatter.allowedUnits = [.minute, .second]
          formatter.unitsStyle = style
          formatter.zeroFormattingBehavior = .pad
          return formatter.string(from: self) ?? ""
    }
}
