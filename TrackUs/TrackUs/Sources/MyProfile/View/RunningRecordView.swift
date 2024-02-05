//
//  RunningRecordView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

struct RunningRecordView: View {
    var body: some View {
        PreparingService()
            .customNavigation {
                NavigationText(title: "러닝기록")
            } left: {
                NavigationBackButton()
            }

    }
}

#Preview {
    RunningRecordView()
}
