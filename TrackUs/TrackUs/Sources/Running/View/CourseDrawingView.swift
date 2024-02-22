//
//  CourseDrawingView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI

struct CourseDrawingView: View {
    var body: some View {
        ZStack {
            CourseDrawingMapView()
                .edgesIgnoringSafeArea(.all)
                
            VStack {
                
            }
            .customNavigation {
                NavigationText(title: "코스등록")
            } left: {
                NavigationBackButton()
            }
        }
    }
}

#Preview {
    CourseDrawingView()
}
