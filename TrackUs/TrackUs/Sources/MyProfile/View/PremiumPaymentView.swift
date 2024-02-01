//
//  PremiumPaymentView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

struct PremiumPaymentView: View {
    var body: some View {
        Text("프리미엄 결제화면 개발중")
            .customNavigation {
                NavigationText(title: "프리미엄 결제")
            } left: {
                NavigationBackButton()
            }

    }
}

#Preview {
    PremiumPaymentView()
}
