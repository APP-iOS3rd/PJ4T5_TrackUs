//
//  DataLoadingView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/21.
//

import SwiftUI

struct DataLoadingView: View {
    @State var isAnimating: Bool = false
    @State var circleStart: CGFloat = 0.17
    @State var circleEnd: CGFloat = 0.325
    
    @State var rotationDegree: Angle = .degrees(0)
    
    let circleTrackGradient = LinearGradient(colors: [.circleTrackStart, .circleTrackEnd], startPoint: .top, endPoint: .bottom)
    let circleFillGradient = LinearGradient(colors: [.circleRoundStart, .circleRoundEnd], startPoint: .topLeading, endPoint: .trailing)
    
    let trackRotation: Double = 2
    let animationDuration: Double = 0.75
    
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .fill(circleTrackGradient)
                    .shadow(color: .label.opacity(0.015), radius: 5, x: 1, y: 1)
                Text("운동 데이터 저장중")
                    .customFontStyle(.gray1_B20)
                Circle()
                    .trim(from: circleStart, to: circleEnd)
                    .stroke(style: .init(lineWidth: 15, lineCap: .round))
                    .fill(circleFillGradient)
                    .rotationEffect(rotationDegree)
            }
            .frame(width: 250, height: 250)
            .onAppear() {
                animateLoader()
            }
        }
    }
    
    func getRotatingAngle() -> Angle {
        return .degrees(360 * trackRotation) + .degrees(120)
    }
    
    func animateLoader() {
        withAnimation(.spring(response: animationDuration * 2)) {
            rotationDegree = .degrees(-57.5)
            circleEnd = 0.325
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(.easeInOut(duration: trackRotation * animationDuration)) {
                self.rotationDegree += self.getRotatingAngle()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            withAnimation(.easeOut(duration: trackRotation * animationDuration / 2.25)) {
                self.circleEnd = 0.95
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: trackRotation * animationDuration, repeats: false) { _ in
            rotationDegree = .degrees(47.5)
            withAnimation(.easeOut(duration: animationDuration)) {
                self.circleEnd = 0.25
            }
        }
    }
}

#Preview {
    DataLoadingView()
}
