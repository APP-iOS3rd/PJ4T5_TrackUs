//
//  Date+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
}
