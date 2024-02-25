//
//  PrivateUserView.swift
//  TrackUs
//
//  Created by 윤준성 on 2/21/24.
//

import SwiftUI

struct PrivateUserView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("Lock")
            Text("프로필 비공개 유저입니다.")
                .customFontStyle(.gray1_B24)
                .padding(8)
            Text("비공개 유저의 러닝 기록은 열람할 수 없습니다.")
                .customFontStyle(.gray2_R15)
            Spacer()
        }
        
    }
}

#Preview {
    PrivateUserView()
}
