//
//  PhysicalView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

struct PhysicalView: View {
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @Binding private var signUpFlow: SignUpFlow
    
    // nickName 데이터값 변경
    @State private var weight: Double?
    @State private var height: Double?
    
    init(signUpFlow: Binding<SignUpFlow>) {
        self._signUpFlow = signUpFlow
    }
    
    var body: some View {
        VStack(spacing: 40){
            Description(title: "신체 정보 입력", detail: "러닝 기록 분석, 칼로리 소모량 등 더욱 정확한 러닝 데이터 분석을 위해서 다음 정보가 필요합니다.")
            
            VStack(spacing: 26){
                SelectPicker(selectedValue: $height, pickerType: .height)
                SelectPicker(selectedValue: $weight, pickerType: .weight)
            }
            Spacer()
            
            MainButton(active: weight != nil && height != nil, buttonText: "다음으로") {
                authViewModel.userInfo.weight = Int(weight!)
                authViewModel.userInfo.height = Int(height!)
                signUpFlow = .ageGender
            }
        }
    }
}
