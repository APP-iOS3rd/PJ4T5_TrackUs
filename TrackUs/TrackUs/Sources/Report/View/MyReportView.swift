//
//  MyReportView.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI

struct MyReportView: View {
    @State private var selectedTab: CircleTab = .day
    @EnvironmentObject var router: Router
    @State var selectedDate: Date? = Date()
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                
                //MARK: - TrackUs Pro
                Button {
                    router.present(fullScreenCover: .payment)
                } label: {
                    GraphicTextCard(title: "TrackUs Pro", subTitle: "상세한 러닝 리포트를 통해 효율적인 러닝을 즐겨보세요.", resource: .iconTrackUsPro2)
                        .modifier(BorderLineModifier())
                }
                //MARK: - 기간별 운동 정보
                
                Text("기간별 운동 정보")
                    .customFontStyle(.gray1_B24)
                    .padding(.top, 24)
                    .padding(.bottom, 8)
                Text("러닝 데이터를 기반으로 통계를 확인합니다.")
                    .customFontStyle(.gray2_R15)
                    .padding(.bottom, 20)
                
                
                // Circle View
                CircleTabView(selectedPicker: $selectedTab, selectedDate: $selectedDate)
                    .padding(.top)
                    .modifier(BorderLineModifier())
                
                //MARK: - 연령대 추세
                
                Text("연령대 추세")
                    .customFontStyle(.gray1_B24)
                    .padding(.top, 24)
                    .padding(.bottom, 8)
                Text("비슷한 연령대의 운동 정보를 비교합니다.")
                    .customFontStyle(.gray2_R15)
                    .padding(.bottom, 20)
                
                // 그래프 View
                AgeGraphView(selectedTab: selectedTab, selectedDate: $selectedDate)
                    .padding(.top)
                    .modifier(BorderLineModifier())
                
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
        }
    }
}

//#Preview {
//    MyReportView(selectedPicker: .day)
//}
