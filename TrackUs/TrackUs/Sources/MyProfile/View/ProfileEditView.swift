//
//  ProfileEditView.swift
//  TrackUs
//
//  Created by 박소희 on 1/31/24.
//

import SwiftUI

enum RunningOption: String, CaseIterable, Identifiable {
    case record = "기록갱신", diet = "다이어트"
    var id: Self { self }
}

struct ProfileEditView: View {
    @State private var selectedImage: Image?
    @State private var nickname: String = ""
    @State private var height: Int?
    @State private var weight: Int?
    @State private var runningOption: String = ""
    @State private var setDailyGoal: Double? = 0.0
    @State private var goalMinValue: Double? = 0.0
    @State private var goalMaxValue: Double? = 40.0
    @State private var isProfilePublic: Bool = false
    @State private var isProfileSaved: Bool = false
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    
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
                            TextField("닉네임을 입력해주세요", text: $nickname)
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
                                    Text("기록갱신").tag("기록갱신")
                                    Text("다이어트").tag("다이어트")
                                }
                                .accentColor(.gray1)
                                .padding(.horizontal, -8)
                            }
                            
                            HStack {
                                Text("일일목표")
                                    .customFontStyle(.gray1_R16)
                                Spacer()
                                Picker(selection: $setDailyGoal, label: Text("일일목표")) {
                                    ForEach(Array(stride(from: 0.0, through: 40.0, by: 0.1)), id: \.self) {
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
                .simultaneousGesture(TapGesture().onEnded {
                })
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            authViewModel.getMyInformation()
            nickname = authViewModel.userInfo.username
            height = authViewModel.userInfo.height ?? 120
            weight = authViewModel.userInfo.weight ?? 30
            runningOption = authViewModel.userInfo.runningOption ?? "-"
            setDailyGoal = authViewModel.userInfo.setDailyGoal ?? 0.0
            isProfilePublic = authViewModel.userInfo.isProfilePublic
        }
        
    }
    
    
    func modifyButtonTapped() {
        authViewModel.userInfo.username = nickname
        authViewModel.userInfo.height = height
        authViewModel.userInfo.weight = weight
        authViewModel.userInfo.runningOption = runningOption
        authViewModel.userInfo.setDailyGoal = setDailyGoal
        authViewModel.userInfo.isProfilePublic = isProfilePublic
        authViewModel.storeUserInformation()
        isProfileSaved = true
        presentationMode.wrappedValue.dismiss()
    }
}
