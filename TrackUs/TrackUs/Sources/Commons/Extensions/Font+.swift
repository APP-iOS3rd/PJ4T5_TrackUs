//
//  Font+.swift
//  TrackUs
//
//  Created by 최주원 on 1/30/24.
//

import SwiftUI

enum CustomFontStyle {
    // MARK: - Gray1 #656565
    // Gray1_Bold
    case gray1_B24
    case gray1_B20
    case gray1_B16
    
    // Gray1_SemiBold
    case gray1_SB16
    
    // Gray1_Medium
    case gray1_M16

    // Gray1_Regular
    case gray1_R16
    case gray1_R14
    case gray1_R12
    
    // MARK: - Gray2 #969696
    // Gray2_Regular
    case gray2_R16
    case gray2_R14
    case gray2_R12
    
    // Gray2_Light
    case gray2_L16
    case gray2_L12
    
    // MARK: - White
    // White_Bold
    case white_B16
    
    // MARK: - Main
    // Main_Bold
    case main_B16
    
    // Main_Regular
    case main_R16
    
    // MARK: - Caution
    // Caution_Regular
    case caution_R16
    
    // Caution_Lihgt
    case caution_L12
}

extension View {
    /**
     # 사용 예시
     - .customTextStyle(.Gray2_R12)
     - .customTextStyle(style: .Gray2_R12)
     
     # case 명칭 규칙
     - Color_WeightSize
     */
    /// .Color_WeightSize   ->   ex) .customTextStyle(.gray1_R16)
    func customFontStyle(_ style: CustomFontStyle) -> some View {
        var font: Font
        var color: Color

        switch style {
            
            // MARK: - Gray1 #656565
        case .gray1_B24:
            font = Font.system(size: 24, weight: .bold)
            color = .gray1
        case .gray1_B20:
            font = Font.system(size: 20, weight: .bold)
            color = .gray1
        case .gray1_B16:
            font = Font.system(size: 16, weight: .bold)
            color = .gray1
            
            // Gray1_SemiBold
        case .gray1_SB16:
            font = Font.system(size: 16, weight: .semibold)
            color = .gray1
            
            // Gray1_Medium
        case .gray1_M16:
            font = Font.system(size: 16, weight: .medium)
            color = .gray1
            
            // Gray1_Regular
        case .gray1_R16:
            font = Font.system(size: 16, weight: .regular)
            color = .gray1
        case .gray1_R14:
            font = Font.system(size: 14, weight: .regular)
            color = .gray1
        case .gray1_R12:
            font = Font.system(size: 12, weight: .regular)
            color = .gray1
            
            // MARK: - Gray2 #969696
            // Gray2_Regular
        case .gray2_R16:
            font = Font.system(size: 16, weight: .regular)
            color = .gray2
        case .gray2_R14:
            font = Font.system(size: 14, weight: .regular)
            color = .gray2
        case .gray2_R12:
            font = Font.system(size: 12, weight: .regular)
            color = .gray2
            
            // Gray2_Light
        case .gray2_L16:
            font = Font.system(size: 16, weight: .light)
            color = .gray2
        case .gray2_L12:
            font = Font.system(size: 12, weight: .light)
            color = .gray2
            
            // MARK: - White
        case .white_B16:
            font = Font.system(size: 16, weight: .bold)
            color = .white
            
            // MARK: - Main
        case .main_B16:
            font = Font.system(size: 16, weight: .bold)
            color = .main
            
            // Main_Regular
        case .main_R16:
            font = Font.system(size: 16, weight: .regular)
            color = .white
            
            // MARK: - Caution
        case .caution_R16:
            font = Font.system(size: 16, weight: .regular)
            color = .caution
        case .caution_L12:
            font = Font.system(size: 12, weight: .light)
            color = .caution
        
        }

        return self
            .font(font)
            .foregroundColor(color)
    }
}
