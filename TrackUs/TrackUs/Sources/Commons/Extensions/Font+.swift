//
//  Font+.swift
//  TrackUs
//
//  Created by 최주원 on 1/30/24.
//

import SwiftUI

enum CustomFontStyle {
    // MARK: - Gray1 #656565
    //Gray1_Heavy
    case gray1_H17
    
    // Gray1_Bold
    case gray1_B24
    case gray1_B20
    case gray1_B16
    
    // Gray1_SemiBold
    case gray1_SB20
    case gray1_SB16
    case gray1_SB17
    case gray1_SB15
    case gray1_SB12

    // Gray1_Medium
    case gray1_M16

    // Gray1_Regular
    case gray1_R16
    case gray1_R14
    case gray1_R12
    case gray1_R11
    case gray1_R9
    
    // MARK: - Gray2 #969696
    // Gray2_Regular
    case gray2_R16
    case gray2_R15
    case gray2_R14
    case gray2_R12
    
    // Gray2_Light
    case gray2_L16
    case gray2_L14
    case gray2_L12
    
    // MARK: - Gray4 #696969
    // Gray4_Regular
    case gray4_R9
    
    // Gray4_Meditum
    case gray4_M12
    
    // MARK: - White
    // White_Bold
    case white_B16
    
    // White_SemiBold
    case white_SB20
    
    // White_Medium
    case white_M14
    
    // MARK: - Main
    // Main_Bold
    case main_B16
    case main_B14
    
    // Main_Regular
    case main_R16
    
    // Main_SemiBold
    case main_SB16
    case main_SB14
    
    // MARK: - Caution
    // Caution_Regular
    case caution_R16
    case caution_R17
    // Caution_Lihgt
    case caution_L12
    
    // MARK: - Blue1 #2E83F1
    // Blue1_Bold
    case blue1_B12
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
            // Gray1_Heavy
        case .gray1_H17:
            font = Font.system(size: 17, weight: .heavy)
            color = .gray1
            
            // Gray1_Bold
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
        case .gray1_SB12:
            font = Font.system(size: 12, weight: .semibold)
            color = .gray1
        case .gray1_SB15:
            font = Font.system(size: 15, weight: .semibold)
            color = .gray1
        case .gray1_SB16:
            font = Font.system(size: 16, weight: .semibold)
            color = .gray1
        case .gray1_SB17:
            font = Font.system(size: 17, weight: .semibold)
            color = .gray1
        case .gray1_SB20:
            font = Font.system(size: 20, weight: .semibold)
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
        case .gray1_R11:
            font = Font.system(size: 11, weight: .regular)
            color = .gray1
        case .gray1_R9:
            font = Font.system(size: 9, weight: .regular)
            color = .gray1
            
            // MARK: - Gray2 #969696
            // Gray2_Regular
        case .gray2_R16:
            font = Font.system(size: 16, weight: .regular)
            color = .gray2
        case .gray2_R15:
            font = Font.system(size: 15, weight: .regular)
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
        case .gray2_L14:
            font = Font.system(size: 14, weight: .light)
            color = .gray2
        case .gray2_L12:
            font = Font.system(size: 12, weight: .light)
            color = .gray2
            
            // MARK: - Gray4 #696969
            // Gray4_Regular
        case .gray4_R9:
            font = Font.system(size: 9, weight: .regular)
            color = .gray4
            
            // Gray4_Medium
        case .gray4_M12:
            font = Font.system(size: 12, weight: .medium)
            color = .gray4
            
            // MARK: - White
        case .white_B16:
            font = Font.system(size: 16, weight: .bold)
            color = .white
            
            // White_SemiBold
        case .white_SB20:
            font = Font.system(size: 20, weight: .semibold)
            color = .white
            
            // White_Medium
        case .white_M14:
            font = Font.system(size: 14, weight: .medium)
            color = .white
            
            // MARK: - Main
        case .main_B14:
            font = Font.system(size: 14, weight: .bold)
            color = .main
        case .main_B16:
            font = Font.system(size: 16, weight: .bold)
            color = .main
            
            // Main_Regular
        case .main_R16:
            font = Font.system(size: 16, weight: .regular)
            color = .main
            
            // Main_SemiBold
        case .main_SB16:
            font = Font.system(size: 16, weight: .semibold)
            color = .main
        case .main_SB14:
            font = Font.system(size: 14, weight: .semibold)
            color = .main
            
            // MARK: - Caution
        case .caution_R16:
            font = Font.system(size: 16, weight: .regular)
            color = .caution
        case .caution_R17:
            font = Font.system(size: 17, weight: .regular)
            color = .caution
        case .caution_L12:
            font = Font.system(size: 12, weight: .light)
            color = .caution
            
            // MARK: - Blue1 - #2E83F1
        case .blue1_B12:
            font = Font.system(size: 12, weight: .bold)
            color = .blue1
        
        }

        return self
            .font(font)
            .foregroundColor(color)
    }
}
