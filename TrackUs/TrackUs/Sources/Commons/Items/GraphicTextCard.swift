//
//  GraphicTextCard.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/14.
//

import SwiftUI

struct GraphicTextCard: View {
    let title: String
    let subTitle: String
    let resource: ImageResource
    
    var body: some View {
        VStack {
            HStack {
                Image(resource)
                VStack(alignment: .leading) {
                    Text(title)
                        .customFontStyle(.main_B14)
                    Text(subTitle)
                        .customFontStyle(.gray1_R12)
                }
                Spacer()
                Image("ChevronRight")
            }
            .padding(7)
        }
        .frame(height: 67)
        .background(.white)
    }
}
