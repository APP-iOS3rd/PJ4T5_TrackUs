//
//  PremiumPaymentView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

struct PremiumPaymentView: View {
    @Binding var isShownFullScreenCover: Bool
    
    var body: some View {
        Text("프리미엄 결제화면 개발중")
            .customNavigation {
                EmptyView()
            } left: {
                Button(action: {
                    isShownFullScreenCover.toggle()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray1)
                })
            }
    }
}

#Preview {
    PremiumPaymentView(isShownFullScreenCover: .constant(true))
}
