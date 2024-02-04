//
//  NavigationLinkCard.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct NavigationLinkCard: View {
    var body: some View {
        VStack {
            HStack {
                Image("Clipboard")
                VStack(alignment: .leading) {
                    Text("러닝 리포트 확인하기")
                        .customFontStyle(.main_B16)
                    Text("러닝 거리, 통계, 달성 기록을 확인할 수 있습니다.")
                        .customFontStyle(.gray1_R12)
                }
                Spacer()
                Image("ChevronRight")
            }
            .padding(12)
        }
    }
}

#Preview {
    NavigationLinkCard()
}
