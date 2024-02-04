//
//  RunningLiveView.swift
//  TrackUs
//
//  Created by 윤준성 on 2/4/24.
//

import SwiftUI

struct RunningLiveView: View {
    @StateObject private var countVM = CountViewModel()

    var body: some View {
        ZStack {
            Image("Shin")
                .resizable()
                .ignoresSafeArea(.all)
            
            Color.black
                .opacity(countVM.isHidden ? 0.0 : countVM.backgroundOpacity)
                .edgesIgnoringSafeArea(.all)

            VStack {
                if !countVM.isHidden {
                    Text("\(countVM.countdown)")
                        .font(.system(size: 128))
                        .italic()
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .onAppear {
                            countVM.startCountdown()
                        }

                    Text("잠시후 러닝이 시작됩니다!")
                        .customFontStyle(.white_SB20)
                }
            }
        }
    }
}

#Preview {
    RunningLiveView()
}
