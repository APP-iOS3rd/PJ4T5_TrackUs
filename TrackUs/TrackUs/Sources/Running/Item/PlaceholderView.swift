//
//  PlaceholderView.swift
//  TrackUs
//
//  Created by 권석기 on 3/19/24.
//

import SwiftUI

struct PlaceholderView: View {
    let title: String
    let message: String
    let maxHeight: CGFloat?
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(.aroundMePlaceholder)
            Text(title)
                .customFontStyle(.gray1_B16)
            
            Text(message)
                .customFontStyle(.gray1_R14)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: maxHeight, alignment: .center)
    }
}
