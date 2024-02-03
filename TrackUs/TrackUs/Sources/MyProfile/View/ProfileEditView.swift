//
//  ProfileEditView.swift
//  TrackUs
//
//  Created by 박소희 on 1/31/24.
//

import SwiftUI

enum RunnningOption: String, CaseIterable, Identifiable {
    case record = "기록갱신", diet = "다이어트"
    var id: Self { self }
}

struct ProfileEditView: View {
    private let runningOptions: [RunnningOption] = [.record, .diet]
    @State private var runningOption: RunnningOption = .record
    @State private var selectedImage: Image? = nil
    @State private var nickname: String = ""
    @State private var height: Int = 170
    @State private var weight: Int = 65
    @State private var goalMinValue: Double = 0.1
    @State private var goalMaxValue: Double = 40.0
    @State private var isProfilePublic: Bool = true
    
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    // MARK: - 프로필 헤더
                    ProfilePicker(image: $selectedImage, size: 116)
                        .padding(.vertical, 12)
                    
                    // MARK: - 프로필 정보
                    VStack(alignment: .leading, spacing: 32) {
                        // 닉네임
                        VStack(alignment: .leading, spacing: 20) {
                            Text("닉네임")
                                .customFontStyle(.gray1_B20)
                            TextField("TrackUs", text: $nickname)
                                .padding(.leading, 16)
                                .foregroundColor(.gray1)
                                .frame(height: 47)
                                .textFieldStyle(PlainTextFieldStyle())
                                .cornerRadius(3)
                                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.border))
                        }
                        
                        /**
                         신체정보 옵션
                         신장 120-250(단위 1)
                         체중 30-200(단위 1)
                         */
                        VStack(alignment: .leading, spacing: 20) {
                            Text("신체정보")
                                .customFontStyle(.gray1_B20)
                            
                            HStack {
                                Text("신장")
                                    .customFontStyle(.gray1_R16)
                                Spacer()
                                Picker(selection: $height, label: Text("신장")) {
                                    ForEach(120..<250, id: \.self) {
                                        Text("\($0) cm")
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .accentColor(.gray1)
                                .padding(.horizontal, -8)
                            }
                            
                            HStack {
                                Text("체중")
                                    .customFontStyle(.gray1_R16)
                                Spacer()
                                Picker(selection: $weight, label: Text("신장")) {
                                    ForEach(30..<200, id: \.self) {
                                        Text("\($0) kg")
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .accentColor(.gray1)
                                .padding(.horizontal, -8)
                            }
                        }
                        .padding(.vertical, 14)
                        
                        /**
                         운동정보 옵션
                         러닝스타일 - 기록갱신/다이어트
                         일일목표 - 0.0-40.0 (0.1 km)
                         */
                        VStack(alignment: .leading, spacing: 20) {
                            Text("운동정보")
                                .customFontStyle(.gray1_B20)
                            
                            HStack {
                                Text("러닝스타일")
                                    .customFontStyle(.gray1_R16)
                                Spacer()
                                Picker(selection: $runningOption, label: Text("러닝 스타일")) {
                                    ForEach(runningOptions) { option in
                                        Text(option.rawValue)
                                        
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .accentColor(.gray1)
                                .padding(.horizontal, -8)
                                
                            }
                            
                            HStack {
                                Text("일일목표")
                                    .customFontStyle(.gray1_R16)
                                Spacer()
                                Picker(selection: $goalMinValue, label: Text("일일목표")) {
                                    ForEach(Array(stride(from: goalMinValue, through: goalMaxValue, by: 0.1)), id: \.self) {
                                        Text("\($0, specifier: "%.1f") km")
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .padding(.horizontal, -8)
                                .accentColor(.gray1)
                            }
                            
                        }
                        .padding(.vertical, 14)
                        
                        // 사용자 관련
                        VStack(alignment: .leading, spacing: 20) {
                            Text("사용자 관련")
                                .customFontStyle(.gray1_B20)
                            
                            HStack {
                                Text("프로필 공개 여부")
                                    .customFontStyle(.gray1_R16)
                                Spacer()
                                Toggle("프로필 공개 여부", isOn: $isProfilePublic)
                                    .toggleStyle(SwitchToggleStyle(tint: Color.green))
                                    .font(Font.system(size: 15, weight: .regular))
                                    .foregroundColor(Color.gray1)
                                    .labelsHidden()
                            }
                            
                        }
                        .padding(.vertical, 14)
                    }
                }
                .padding(.horizontal, Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
            }
            .customNavigation {
                NavigationText(title: "프로필 변경")
            } left: {
                NavigationBackButton()
            }
            MainButton(active: true, buttonText: "수정완료", action: modifyButtonTapped)
                .padding(Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func modifyButtonTapped() {}
}

#Preview {
    ProfileEditView()
}
