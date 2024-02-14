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
                    HStack {
                        Image(.iconTrackUsPro2)
                        VStack(alignment: .leading) {
                            Text("TrackUs Pro")
                                .customFontStyle(.main_SB14)
                            Text("상세한 러닝 리포트를 통해 효율적인 러닝을 즐겨보세요")
                                .customFontStyle(.gray4_M12)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.gray3)
                    )
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.gray3)
                    )
                
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.gray3)
                    )
                
            }
            .padding(.top)
            .padding(.bottom, 10)
            .padding(.horizontal, 16)
        }
    }
}

//#Preview {
//    MyReportView(selectedPicker: .day)
//}
