//
//  HorizontalGraph.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI

struct HorizontalGraph: View {
    @State var selectedBarIndex: Int? = nil
    
    let maxWidth: CGFloat = 130 // 최대 그래프 넓이
    let distanceLigitValue: Double = 20.0 // 최대 한계 값 거리
    let speedLimitValue: Double = 20.0 // 최대 한계 값 속도
    @Binding var selectedAge : AvgAge
    
    var formattedCurrentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.string(from: Date())
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack() {
                
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.gray2)
                Text("OO님") // 사용자의 이름
                    .customFontStyle(.gray1_R11)
                
                Spacer()
            }
            
            HStack {
                
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.main)
                Text("TrackUs \(selectedAge.rawValue)") // 사용자의 나이대
                    .customFontStyle(.gray1_R12)
            }
            .padding(.bottom, 20)
            
            VStack {
                HStack(spacing: 17) {
                    Text("러닝 거리")
                        .customFontStyle(.gray1_SB15)
                    
                    VStack {
                        SpeedBar(value: 40, speedValue: 3.3)
                            .foregroundColor(.gray2)
                            .padding(.bottom, 10)
                        SpeedBar(value: 40, speedValue: 4.6)
                            .foregroundColor(.main)
                    }
                }
                .padding(.bottom, 20)
                
                HStack(spacing: 17) {
                    Text("러닝 속도")
                        .customFontStyle(.gray1_SB15)
                    
                    VStack {
                        DistanceBar(value: 30, DistanceValue: 12)
                            .foregroundColor(.gray2)
                            .padding(.bottom, 10)
                        DistanceBar(value: 30, DistanceValue: 14)
                            .foregroundColor(.main)
                    }
                }
            }
            
        }
    }
}

struct SpeedBar: View {
    var value : Double
    var speedValue: Double
    
    var body: some View {
        
        HStack {
            
            ZStack(alignment: .leading){
                
                Capsule().frame(width: 130, height: 12) // 그래프 높이
                    .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0))
                Capsule().frame(width: value, height: 15)
                
                Text("\(String(format: "%0.1f", speedValue)) km")
                    .customFontStyle(.gray1_R9)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .offset(x: +value + 10)
            }
        }
    }
}

struct DistanceBar: View {
    var value : Double
    var DistanceValue: Double
    
    var body: some View {
        
        HStack {
            
            ZStack(alignment: .leading){
                
                Capsule().frame(width: 130, height: 12) // 그래프 높이
                    .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0))
                Capsule().frame(width: value, height: 15)
                
                Text("\(String(format: "%0.1f", DistanceValue)) km/h")
                    .customFontStyle(.gray1_R9)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .offset(x: +value + 10)
            }
        }
    }
}

//#Preview {
//    HorizontalGraph()
//}
