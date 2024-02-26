//
//  NoParticipationPlaceholderView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/26.
//

import SwiftUI

struct NoParticipationPlaceholderView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(.aroundMePlaceholder)
            Text("참여중인 러닝이 존재하지 않습니다.")
                .customFontStyle(.gray1_B16)
            
            Text("러닝 메이트 모집 기능을 통해 직접 러닝 모임을 만들어보세요!")
                .customFontStyle(.gray1_R14)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    NoParticipationPlaceholderView()
}
