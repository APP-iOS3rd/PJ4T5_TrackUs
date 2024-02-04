//
//  NavigationLinkCard.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct NavigationLinkCard: View {
    let title: String
    let subTitle: String
    
    var body: some View {
        VStack {
            HStack {
                Image("Clipboard")
                VStack(alignment: .leading) {
                    Text(title)
                        .customFontStyle(.main_B16)
                    Text(subTitle)
                        .customFontStyle(.gray1_R12)
                }
                Spacer()
                Image("ChevronRight")
            }
            
            
            .padding(7)
        }
        .background(.white)
    }
}

//#Preview {
//    NavigationLinkCard()
//}
