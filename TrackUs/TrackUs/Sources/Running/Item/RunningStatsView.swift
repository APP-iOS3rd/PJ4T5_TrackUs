//
//  RunningStatsView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI

struct RunningStatsView: View {
    let estimatedTime: Double
    let calories: Double
    let distance: Double
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(.shose)
                Text("러닝 거리")
                    .customFontStyle(.gray1_R16)
                    .foregroundStyle(Color.init(hex: 0x3d3d3d))
                Text(distance.asString(unit: .kilometer))
                    .customFontStyle(.gray1_R14)
            }
            Spacer()
            VStack {
                Image(.fire)
                Text("예상 칼로리")
                    .customFontStyle(.gray1_R16)
                Text(calories.asString(unit: .calorie))
                    .customFontStyle(.gray1_R14)
            }
            Spacer()
            VStack {
                Image(.time)
                Text("예상 시간")
                    .customFontStyle(.gray1_R16)
                Text(estimatedTime.asString(style: .positional))
                    .customFontStyle(.gray1_R14)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .modifier(BorderLineModifier())
    }
}


//#Preview {
//    RunningStatsView()
//}
