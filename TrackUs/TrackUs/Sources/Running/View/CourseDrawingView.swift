//
//  CourseDrawingView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI

struct CourseDrawingView: View {
    @StateObject var courseRegViewModel = CourseRegViewModel()
    @EnvironmentObject var router: Router
    var body: some View {
        CourseDrawingMapView(
            courseRegViewModel: courseRegViewModel,
            router: router)
                .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    CourseDrawingView()
}
