//
//  CircleView.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI

enum CircleTab: String, CaseIterable {
    case day = "일"
    case month = "월"
}

struct CircleTabView: View {
    @State private var selectedPicker: CircleTab = .day
    @Namespace private var animation
    
    var body: some View {
        VStack {
            ZStack {
                animate()
                
                Button {
                    
                } label: {
                    Image("Calendar")
                        
                }
                .offset(x: 150, y: -15)

            }
            
//            Spacer()
            
            CircleSelectView(selec: selectedPicker)
        }
    }
    
    @ViewBuilder
    private func animate() -> some View {
        HStack {
            ForEach(CircleTab.allCases, id: \.self) { item in
                ZStack {
                    if selectedPicker == item {
                        Capsule()
                            .foregroundColor(.main)
                            .frame(height: 30)
                            .matchedGeometryEffect(id: "일별", in: animation)
                    }
                    
                    Text(item.rawValue)
                        .frame(maxWidth: .infinity / 2)
                        .frame(height: 30)
                        .customFontStyle(selectedPicker == item ? .white_M14 : .gray2_L14)
                    // FFFFFF Medium 14 , gray2 Light 14
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
        .overlay(
            Capsule()
                .stroke(lineWidth: 2)
                .foregroundStyle(.gray.opacity(0.2))
        )
        .padding(.horizontal, 89)
        .padding(.bottom, 23)
    }
}

struct CircleSelectView: View {
    var selec: CircleTab
    
    var body: some View {
        switch selec {
        case .day:
            CircleView()
        case .month:
            MonthlyCircleView()
        }
    }
}

struct CircleView: View {
    @State private var progress: CGFloat = 0.5
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundColor(.gray2)
                }
                
                Text("2024년 2월 9일")
                    .customFontStyle(.gray1_B20)
                    .padding(.horizontal, 10)
                
                Button {
                    
                } label: {
                    Image(systemName: "arrowtriangle.right.fill")
                        .foregroundColor(.gray2)
                }
            }
            .padding(.bottom, 30)
            
            ZStack {
                CircularProgressView(progress: progress)
                    .padding(.horizontal, 96)
                
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Text("목표 거리량")
                            .customFontStyle(.blue1_B12) // 2E83F1 Bold 12
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .frame(width: 13, height: 13)
                            .foregroundColor(.blue1) // 2E83F1
                    }
                    Text("3.2Km / 5Km")
                        .customFontStyle(.gray1_H17) // gray1 Heavy 17
                        .italic()
                }
            }
            
            HStack {
                VStack(spacing: 7) {
                    Text("151")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("칼로리")
                        .customFontStyle(.gray2_R15) // gray2 Regular 15
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("3.2km")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("킬로미터")
                        .customFontStyle(.gray2_R15) // gray2 Regular 15
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("00:32")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("시간")
                        .customFontStyle(.gray2_R15) // gray2 Regular 15
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("_'__'")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("평균 페이스")
                        .customFontStyle(.gray2_R15) // gray2 Regular 15
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 30)
        }
    }
}

struct MonthlyCircleView: View {
    @State private var progress: CGFloat = 0.5
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundColor(.gray2)
                }
                
                Text("2024년 2월")
                    .customFontStyle(.gray1_B20)
                    .padding(.horizontal, 27)
                
                Button {
                    
                } label: {
                    Image(systemName: "arrowtriangle.right.fill")
                        .foregroundColor(.gray2)
                }
            }
            .padding(.bottom, 30)
            
            ZStack {
                CircularProgressView(progress: progress)
                    .padding(.horizontal, 96)
                
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Text("목표 거리량")
                            .customFontStyle(.blue1_B12) // 2E83F1 Bold 12
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .frame(width: 13, height: 13)
                            .foregroundColor(.blue1) // 2E83F1
                    }
                    Text("3.2Km / 5Km")
                        .customFontStyle(.gray1_H17) // gray1 Heavy 17
                        .italic()
                }
            }
            
            HStack {
                VStack(spacing: 7) {
                    Text("151")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("칼로리")
                        .customFontStyle(.gray2_R15) // gray2 Regular 15
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("3.2km")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("킬로미터")
                        .customFontStyle(.gray2_R15) // gray2 Regular 15
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("00:32")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("시간")
                        .customFontStyle(.gray2_R15) // gray2 Regular 15
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("_'__'")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("평균 페이스")
                        .customFontStyle(.gray2_R15) // gray2 Regular 15
                }
                
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 30)
        }
    }
}

struct CircularProgressView: View {
    var progress: CGFloat
    @State private var animatedProgress: CGFloat = 0.0 // 애니메이션을 위한

    var body: some View {
        ZStack {
            // 원형 트랙
            Circle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 12.0, lineCap: .round))
                .overlay(
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(.gray.opacity(0.2))
                        .padding(7)
                )
                .overlay(
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(.gray.opacity(0.2))
                        .padding(-7)
                )

            // 원형 그래프
            Circle()
                .trim(from: 0.0, to: animatedProgress)
//                .stroke(Color.main, style: StrokeStyle(lineWidth: 13.0, lineCap: .round))
                .stroke(LinearGradient(gradient: Gradient(colors: [Color.main, Color.main.opacity(0.2)]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 13.0, lineCap: .round))
                .rotationEffect(Angle(degrees: 90))
                .onAppear {
                    // 애니메이션 적용
                    
                    withAnimation(.easeInOut(duration: 0.65)) {
                        animatedProgress = progress
                    }
                }
        }
    }
}

#Preview {
//    CircleView()
    CircleTabView()
//    MonthlyCircleView()
}
