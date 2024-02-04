//
//  RunningResultView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct RunningResultView: View {
    @EnvironmentObject var router: Router
    var body: some View {
        VStack {
            Button(action: {router.popToRoot()}, label: {
                Text("홈으로")
            })
        }
    }
}

#Preview {
    RunningResultView()
}
