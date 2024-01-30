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
        Text("러닝뷰")
        .customNavigation {
            Text("center View")
        } left: {
            Button(action: {router.pop()}) {
                Text("left View")
            }
        } right: {
            Text("right View")
        }
    }
}

#Preview {
    RunningView()
}
