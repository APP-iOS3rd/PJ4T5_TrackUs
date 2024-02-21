//
//  RunningMateDetailView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI

struct RunningMateDetailView: View {
    var body: some View {
        VStack {
            
        }
            .customNavigation {
                NavigationText(title: "모집글 상세보기")
            } left: {
                NavigationBackButton()
            }

    }
}

#Preview {
    RunningMateDetailView()
}
