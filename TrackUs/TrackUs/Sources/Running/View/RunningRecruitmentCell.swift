//
//  RunningRecruitmentCell.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct RunningRecruitmentCell: View {
    var body: some View {
        VStack {
            Image("MapPath")
                .resizable()
                .frame(height: 140)
            VStack(alignment: .leading, spacing: 6) {
                Text("2024.01.12")
                    .customFontStyle(.gray2_R12)
                
                Text("광명시 러닝 메이트 구합니다")
                    .customFontStyle(.gray1_B16)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Label("서울숲 카페거리", systemImage: "location")
                            .customFontStyle(.gray2_L12)
                        Spacer()
                        Label("3/6", systemImage: "person.2.fill")
                            .customFontStyle(.gray2_L12)
                    }
                    HStack {
                        Label("10:02 AM", systemImage: "clock")
                            .customFontStyle(.gray2_L12)
                        Spacer()
                        Label("1.72km", systemImage: "flag.2.crossed")
                            .customFontStyle(.gray2_L12)
                    }
                }
            }
            .padding(12)
        }
        .frame(width: 176)
        .background(.white)
        .cornerRadius(12)
        .clipped()
        .shadow(color: .divider, radius: 5, x: 0, y: 0)
    }
}

#Preview {
    RunningRecruitmentCell()
}
