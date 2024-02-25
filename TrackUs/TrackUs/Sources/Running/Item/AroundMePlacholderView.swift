//
//  AroundMePlacholderView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/25.
//

import SwiftUI

struct AroundMePlacholderView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(.aroundMePlaceholder)
            Text("근처 러닝 모임이 존재하지 않습니다.")
                .customFontStyle(.gray1_B16)
            Text("러닝 메이트 모집 기능을 통해 직접 러닝 모임을 만들어보세요!")
                .customFontStyle(.gray1_R14)
        }
        .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
    }
}

#Preview {
    AroundMePlacholderView()
}
