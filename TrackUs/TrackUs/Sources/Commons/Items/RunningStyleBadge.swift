//
//  RunningStyleBadge.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI

struct RunningStyleBadge: View {
    let style: RunningStyle
    
    var body: some View {
        Text(style.description)
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
