//
//  CourseDrawingView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI

struct CourseDrawingView: View {
    var body: some View {
            CourseDrawingMapView()
                .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    CourseDrawingView()
}
