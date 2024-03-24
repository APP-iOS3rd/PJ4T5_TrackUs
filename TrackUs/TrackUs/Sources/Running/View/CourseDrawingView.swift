//
//  CourseDrawingView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI

struct CourseDrawingView: View {
    @StateObject var courseViewModel = CourseViewModel(course: Course.createObject())
    @EnvironmentObject var router: Router
    var body: some View {
        CourseDrawingMapView(
            courseViewModel: courseViewModel,
            router: router)
                .edgesIgnoringSafeArea(.all)
    }
}
