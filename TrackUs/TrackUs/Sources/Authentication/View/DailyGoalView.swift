//
//  DailyGoalView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

struct DailyGoalView: View {
    @Binding private var signUpFlow: SignUpFlow
    
    // nickName 데이터값 변경
    @State private var goal : Double?
    @State private var goalPicker: Bool = false
    
    init(signUpFlow: Binding<SignUpFlow>) {
        self._signUpFlow = signUpFlow
    }
    
    var body: some View {
        VStack(spacing: 26){
            Description(title: "일일 운동량", detail: "하루에 정해진 운동량을 설정하고 꾸준히 뛸 수 있는 이유를 만들어 주세요.")
            SelectPicker(selectedValue: $goal, showingSheet: $goalPicker, title: "키", unit: "cm")
            
            Spacer()
            
            MainButton(active: goal != nil, buttonText: "다음으로") {
                
            }
        }
    }
}
