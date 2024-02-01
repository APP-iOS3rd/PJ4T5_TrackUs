//
//  MenuItems.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

struct MenuItems<Content>: View where Content: View {
    let sectionTitle: String
    let content: () -> Content
    
    init(sectionTitle: String, @ViewBuilder content: @escaping () -> Content) {
        self.sectionTitle = sectionTitle
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(sectionTitle)
                    .customFontStyle(.gray1_SB16)
                Spacer()
            }
            
            
            VStack(spacing: 20) {
                content()
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
    }
}


struct MenuItem: View {
    let title: String
    var image: Image?
    var label: String = ""
    
    var body: some View {
        HStack {
            Text(title)
                .customFontStyle(.gray1_R16)
            Spacer()
            if let image = image {
                image
            } else {
                Text(label)
                    .customFontStyle(.gray1_R16)
            }
        }
        
    }
}
