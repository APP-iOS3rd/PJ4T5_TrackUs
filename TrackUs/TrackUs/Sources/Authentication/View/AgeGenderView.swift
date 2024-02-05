//
//  AgeGenderView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

struct AgeGenderView: View {
    @EnvironmentObject var userInfoViewModel : UserInfoViewModel
    @Binding private var signUpFlow: SignUpFlow
    
    // nickName 데이터값 변경
    @State private var selectedAge: Double?
    @State private var AgePicker: Bool = false
    
    @State private var selectedGender: Bool?
    
    init(signUpFlow: Binding<SignUpFlow>) {
        self._signUpFlow = signUpFlow
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40){
            Description(title: "연령대 및 성별", detail: "연령대 정보를 선택하면 더욱 정확한 러닝 데이터 및 칼로리 소모량을 측정할 수 있습니다.")
            
            VStack(alignment: .leading, spacing: 26){
                SelectPicker(selectedValue: $selectedAge, pickerType: .age)
                VStack(alignment: .leading, spacing: 20){
                    Text("성별")
                        .customFontStyle(.gray1_R16)
                    HStack(spacing: 15){
                        SelectButton(image: [Image(.maleMain), Image(.maleGray1)],text: "남성", selected: selectedGender == true, widthSize: 92){
                            selectedGender = true
                        }
                        SelectButton(image: [Image(.femaleMain), Image(.femaleGray1)],text: "여성", selected: selectedGender == false, widthSize: 92){
                            selectedGender = false
                        }
                    }
                }
            }
            Spacer()
            
            MainButton(active: selectedAge != nil && selectedGender != nil, buttonText: "다음으로") {
                userInfoViewModel.userInfo.age = Int(selectedAge!)
                userInfoViewModel.userInfo.gender = selectedGender
                signUpFlow = .runningStyle
            }
        }
    }
}
