//
//  AgeGraphView.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI

struct AgeGraphView: View {
    var body: some View {
        VStack {
            HStack {
                Text("2월 운동량")
                    .customFontStyle(.gray1_SB16)
                
                Spacer()
                
                Button {
                    
                } label: {
                    HStack {
                        Text("20대")
                            .customFontStyle(.gray1_SB12) // gray1 semibold 12
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.gray1)
                    }
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth: 1)
                            .foregroundColor(.gray1)
                    )
                }
            }
            
            HStack(spacing: 3) {
                Text("동일 연령대의 TrackUs 회원 중").customFontStyle(.gray2_R12)
                Text("상위").customFontStyle(.gray2_R12)
                Text("\(33.2, specifier: "%.1f")%").customFontStyle(.gray1_R12).bold()
                Text("(운동량 기준)").customFontStyle(.gray2_R12)
                
                Spacer()
            }
            
            // 가로 그래프
            HorizontalGraph()
                .padding(.top, 14)
                .padding(.bottom, 40)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("평균 운동량 추세")
                        .customFontStyle(.gray1_SB16)
                        .padding(.bottom, 5)
                    Text("그래프를 터치하여 월별 피드백을 확인해보세요.")
                        .customFontStyle(.gray2_R12)
                }
                
                Spacer()
            }
            
            // 꺽은선 + 막대 그래프
//            BarGraphView()
//                .padding(.top, 14)
//                .padding(.bottom, 40)
            WeakGraphView()
                .padding(.top, 14)
                .padding(.bottom, 40)
            
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    AgeGraphView()
}
