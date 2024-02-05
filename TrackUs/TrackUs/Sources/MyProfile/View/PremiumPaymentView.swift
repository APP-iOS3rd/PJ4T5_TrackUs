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
        PreparingService()
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
