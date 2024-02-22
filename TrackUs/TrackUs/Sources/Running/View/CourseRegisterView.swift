//
//  CourseRegisterView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import SwiftUI

struct CourseRegisterView: View {
    @ObservedObject var courseRegViewModel: CourseRegViewModel
    var body: some View {
        VStack {
            ScrollView {
                PathPreviewMap(coordinates: courseRegViewModel.coorinates)
                    .frame(height: 250)
                    .cornerRadius(12)
            }
            MainButton(buttonText: "코스 등록하기") {
                
            }
           
        } .padding(.horizontal, 16)
            .customNavigation {
                NavigationText(title: "코스 등록")
            } left: {
               NavigationBackButton()
            }
    }
}

//#Preview {
//    CourseRegisterView()
//}
