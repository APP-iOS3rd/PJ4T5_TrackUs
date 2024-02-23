//
//  RunningStartView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/19.
//

import SwiftUI

struct RunningStartView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        TrackingModeMapView(router: router)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .preventGesture()
    }
}

#Preview {
    RunningStartView()
}
