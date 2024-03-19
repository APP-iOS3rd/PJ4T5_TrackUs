//
//  RunningStartView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/19.
//

import SwiftUI

struct RunningStartView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var trackingViewModel: TrackingViewModel
    
    var body: some View {
        TrackingModeMapView(router: router, trackingViewModel: trackingViewModel)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .preventGesture()
    }
}
