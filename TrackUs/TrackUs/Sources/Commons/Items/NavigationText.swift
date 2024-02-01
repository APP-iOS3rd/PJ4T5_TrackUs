//
//  NavigationText.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

struct NavigationText: View {
    let title: String
    
    var body: some View {
        Text(title)
            .customFontStyle(.gray1_SB16)
    }
}

#Preview {
    NavigationText(title: "네비게이션 타이틀")
}
