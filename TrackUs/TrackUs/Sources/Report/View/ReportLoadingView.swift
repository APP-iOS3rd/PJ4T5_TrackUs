//
//  ReportLoadingView.swift
//  TrackUs
//
//  Created by 박선구 on 2/18/24.
//

import SwiftUI

// 데이터를 로딩중일때 나오는 뷰

struct ReportLoadingView: View {
    @State private var isAnimating = false
    var body: some View {
        ScrollView {
            VStack {
                Rectangle()
                    .frame(height: 67)
                    .foregroundColor(.gray3)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray3, lineWidth: 1)
                    )
                    .opacity(isAnimating ? 0.3 : 1.0)
                
                HStack {
                    Rectangle()
                        .frame(width: 200, height: 30)
                        .foregroundColor(.gray3)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.gray3, lineWidth: 1)
                        )
                        .opacity(isAnimating ? 0.3 : 1.0)
                    
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.bottom, 8)
                
                HStack {
                    Rectangle()
                        .frame(width: 300, height: 15)
                        .foregroundColor(.gray3)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.gray3, lineWidth: 1)
                        )
                        .opacity(isAnimating ? 0.3 : 1.0)
                    
                    Spacer()
                }
                .padding(.bottom, 20)
                
                Rectangle()
                    .frame(height: 400)
                    .foregroundColor(.gray3)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray3, lineWidth: 1)
                    )
                    .opacity(isAnimating ? 0.3 : 1.0)
                
                HStack {
                    Rectangle()
                        .frame(width: 200, height: 30)
                        .foregroundColor(.gray3)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.gray3, lineWidth: 1)
                        )
                        .opacity(isAnimating ? 0.3 : 1.0)
                    
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.bottom, 8)
                
                HStack {
                    Rectangle()
                        .frame(width: 300, height: 15)
                        .foregroundColor(.gray3)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.gray3, lineWidth: 1)
                        )
                        .opacity(isAnimating ? 0.3 : 1.0)
                    
                    Spacer()
                }
                .padding(.bottom, 20)
                
                Rectangle()
                    .frame(height: 600)
                    .foregroundColor(.gray3)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray3, lineWidth: 1)
                    )
                    .opacity(isAnimating ? 0.3 : 1.0)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .onAppear {
                withAnimation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
        }
    }
}

#Preview {
    ReportLoadingView()
}
