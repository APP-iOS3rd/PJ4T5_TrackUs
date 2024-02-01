//
//  MenuItems.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

struct MenuItems<Section, Content>: View where Content: View, Section: View {
    let section: () -> Section
    let content: () -> Content
    
    init(@ViewBuilder section: @escaping () -> Section, @ViewBuilder content: @escaping () -> Content) {
        self.section = section
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                section()
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
