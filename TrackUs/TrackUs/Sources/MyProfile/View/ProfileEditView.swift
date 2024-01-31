//
//  ProfileEditView.swift
//  TrackUs
//
//  Created by 박소희 on 1/31/24.
//

import SwiftUI

struct ProfileEditView: View {
    @EnvironmentObject var router: Router
    @State private var selectedImage: Image? = nil
    @State private var nickname: String = ""
    
    var body: some View {
        ScrollView{
            ProfilePicker(image: $selectedImage)
                .frame(width: 116, height: 116)
                .padding()
            
            VStack(alignment: .leading) {
                Text("닉네임")
                    .customFontStyle(.gray1_R16)
                TextField("닉네임을 입력하세요", text: $nickname)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity) // TextField의 넓이를 최대로 조정
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.gray3, lineWidth: 1)
                    )
            }
            .padding()
            
            ListItems()
                .padding(.trailing)
            
            // 저장하기 버튼 추가
            saveButton
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
        .customNavigation {
            Text("프로필 변경")
                .customFontStyle(.gray1_SB16)
        } left: {
            NavigationBackButton()
        }
    }
    
    var saveButton: some View {
        Button(action: {
            // 저장하기 버튼 눌렀을 때의 동작
        }) {
            Text("저장하기")
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}
    
struct ListItems: View {
    @State private var height: Int = 170
    @State private var weight: Int = 65
    @State private var runningStyleIndex: Int = 0
    @State private var dailyGoalIndex: Int = 0
    @State private var isProfilePublic: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.ViewLayout.VIEW_STANDARD_VERTICAL_SPACING) {
            Text("신체정보")
                .customFontStyle(.gray1_SB20)
                .padding(.leading)
            
            HStack {
                Text("신장")
                    .customFontStyle(.gray1_R16)
                Spacer()
                Picker(selection: $height, label: Text("신장")) {
                    ForEach(100..<200) {
                        Text("\($0) cm")
                            .foregroundColor(Color.gray1)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                .frame(width: 100)
                .customFontStyle(.gray1_R16)
            }
            .padding(.horizontal)
            
            HStack {
                Text("체중")
                    .customFontStyle(.gray1_R16)
                Spacer()
                Picker(selection: $weight, label: Text("체중")) {
                    ForEach(30..<200) {
                        Text("\($0) kg")
                            .foregroundColor(Color.gray1)
                    }
                }
                .frame(width: 100)
                .customFontStyle(.gray1_R16)
            }
            .padding(.horizontal)
            
            
            Text("운동정보")
                .customFontStyle(.gray1_SB20)
                .padding(.leading)
            
            HStack {
                Text("러닝 스타일")
                    .customFontStyle(.gray1_R16)
                Spacer()
                Picker(selection: $runningStyleIndex, label: Text("러닝 스타일")) {
                    ForEach(0..<3) { index in
                        Text(["가벼운 러닝", "무거운 러닝", "전문 러닝"][index])
                    }
                }
                .frame(width: 150)
                .pickerStyle(DefaultPickerStyle())
                .customFontStyle(.gray1_R16)
            }
            .padding(.horizontal)
            
            HStack {
                Text("일일목표")
                    .customFontStyle(.gray1_R16)
                Spacer()
                Picker(selection: $dailyGoalIndex, label: Text("일일목표")) {
                    ForEach(1..<100) {
                        Text("\($0) km")
                    }
                }
                .frame(width: 100)
                .pickerStyle(DefaultPickerStyle())
                .customFontStyle(.gray1_R16)
            }
            .padding(.horizontal)
            Text("사용자 관련")
                .customFontStyle(.gray1_SB20)
                .padding(.leading)
            Toggle("프로필 공개 여부", isOn: $isProfilePublic)
                .toggleStyle(SwitchToggleStyle(tint: Color.green))
                .font(Font.system(size: 15, weight: .regular))
                .foregroundColor(Color.gray1)
                .padding(.horizontal)
        }
    }
}



#Preview {
    ProfileEditView()
}
