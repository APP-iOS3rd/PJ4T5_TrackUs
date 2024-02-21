//
//  Color.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    static let Main = Color("Main")
    static let Gray1 = Color("Gray1")
    static let Gray2 = Color("Gray2")
    static let Gray3 = Color("Gray3")
    static let Caution = Color("Caution")
    static let Secondary = Color("Secondary")
    
    static let background: Color = Color(UIColor.systemBackground)
    static let label: Color = Color(UIColor.label)
    
    static let circleTrackStart: Color = Color(hex: 0xedf2ff)
    static let circleTrackEnd: Color = Color(hex: 0xebf8ff)
    static let circleRoundStart: Color = Color(hex: 0x47c6ff)
    static let circleRoundEnd: Color = Color(hex: 0x5a83ff)
    
}
