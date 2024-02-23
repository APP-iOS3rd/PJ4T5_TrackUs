//
//  RunningStyleBadge.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI

// 러닝스타일 뱃지
enum RunningType: String {
    case walking = "걷기"
    case jogging = "조깅"
    case running = "달리기"
    case interval = "인터벌"
}
struct RunningStyleBadge: View {
    let style: RunningType
    
    var body: some View {
        Text(style.rawValue)
            .foregroundColor(.white)
            .font(.system(size: 11))
            .fontWeight(.semibold)
            .padding(.horizontal, 9)
            .padding(.vertical, 3)
            .background(Color.main)
            .clipShape(Capsule())
    }
}

#Preview {
    RunningStyleBadge(style: .walking)
}
