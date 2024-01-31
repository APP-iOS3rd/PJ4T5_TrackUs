//
//  RunningView.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import SwiftUI

struct RunningView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        Text("러닝 뷰")
            .customNavigation {
                Text("dd")
            } right: {
                Text("dd")
            }


    }
}

#Preview {
    RunningView()
}
