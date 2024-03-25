//
//  Date+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import Foundation

extension Date {
    enum Format {
        case full // yyyy.mm.dd
        case time // hh:mm
    }
    
    /// Date -> String
    func formattedString(style: Date.Format = .full) -> String {
        let dateFormatter = DateFormatter()
        switch style {
        case .full:
            dateFormatter.dateFormat = "yyyy.MM.dd"
        case .time:
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
        }
        return dateFormatter.string(from: self)
    }
    
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }

    func isSameDay(_ date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
}
