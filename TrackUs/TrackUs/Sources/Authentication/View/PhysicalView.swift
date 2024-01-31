//
//  PhysicalView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

struct PhysicalView: View {
    @Binding private var signUpFlow: SignUpFlow
    
    // nickName 데이터값 변경
    @State private var weight: Double?
    @State private var height: Double?
    @State private var weightPicker: Bool = false
    @State private var heightPicker: Bool = false
    
    @State private var availability: Bool = false
    
    init(signUpFlow: Binding<SignUpFlow>) {
        self._signUpFlow = signUpFlow
    }
    
    var body: some View {
        VStack(spacing: 40){
            Description(title: "신체 정보 입력", detail: "러닝 기록 분석, 칼로리 소모량 등 더욱 정확한 러닝 데이터 분석을 위해서 다음 정보가 필요합니다.")
            
            VStack(spacing: 26){
                SelectPicker(selectedValue: $height, showingSheet: $heightPicker, title: "키", unit: "cm")
                SelectPicker(selectedValue: $weight, showingSheet: $weightPicker, title: "체중", unit: "kg")
            }
            Spacer()
            
            MainButton(active: weight != nil && height != nil, buttonText: "다음으로") {
                signUpFlow = .ageGender
            }
        }
//        .overlay(alignment: .center) {
//            if weightPicker {
//                PickerSheet(selectedValueBinding: $weight, check: $weightPicker, title: "체중", unit: "kg", rangeFrom: 20, rangeThrough: 150, rangeBy: 1, selectedValue: weight != nil ? weight! : 70)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(!weightPicker ? Color.white : Color.black.opacity(0.45))
//                    .edgesIgnoringSafeArea(.all)
//            }
//            if heightPicker {
//                PickerSheet(selectedValueBinding: $height, check: $heightPicker, title: "키", unit: "cm", rangeFrom: 100, rangeThrough: 250, rangeBy: 1, selectedValue: height != nil ? height! : 160)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(!heightPicker ? Color.white : Color.black.opacity(0.45))
//                    .edgesIgnoringSafeArea(.all)
//            }
//        }
//        .animation(.easeOut(duration: 0.2), value: weightPicker)
//        .animation(.easeOut(duration: 0.2), value: heightPicker)
    }
}
