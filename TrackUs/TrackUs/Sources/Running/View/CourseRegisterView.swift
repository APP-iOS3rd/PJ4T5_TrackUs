//
//  CourseRegisterView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import SwiftUI

/**
  코스등록뷰
 */
struct CourseRegisterView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var courseRegViewModel: CourseRegViewModel
    
    @State private var isDatePickerPresented = false
    @State private var isTimePickerPresented = false
    @State private var isTooltipDisplay = false
    
    private var isTimeSetting: Bool {
        courseRegViewModel.hours != 0 && courseRegViewModel.minutes != 0 && courseRegViewModel.seconds != 0
    }
    
    private var formattedHours: String {
        String(format: "%02d", isTimeSetting ? courseRegViewModel.hours : courseRegViewModel.estimatedTime.secondsInHours)
    }
    
    private var formattedMinutess: String {
        String(format: "%02d", isTimeSetting ? courseRegViewModel.minutes : courseRegViewModel.estimatedTime.secondsInMinutes)
    }
    
    private var formattedSeconds: String {
        String(format: "%02d", isTimeSetting ? courseRegViewModel.seconds : courseRegViewModel.estimatedTime.seconds)
    }
    
    private var isTextFieldValid: Bool {
        courseRegViewModel.title.count > 0 && courseRegViewModel.content.count > 0
    }
}

// MARK: - Main View
extension CourseRegisterView {
    var body: some View {
        VStack {
            ScrollView {
                PathPreviewMap(
                    mapStyle: .numberd,
                    isUserInteractionEnabled: false,
                    coordinates: courseRegViewModel.coorinates
                )
                .frame(height: 250)
                .cornerRadius(12)
                .padding(.top, 5)
                .padding(.horizontal, 16)
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("예상 러닝 결과")
                                .customFontStyle(.gray1_B16)
                            Button(action: {
                                isTooltipDisplay = true
                            }) {
                                Image(systemName: "questionmark.circle")
                                    .foregroundStyle(.main)
                                    .font(.caption)
                            }
                        }
                        RunningStats(
                            estimatedTime: courseRegViewModel.estimatedTime,
                            calories: courseRegViewModel.estimatedCalorie,
                            distance: courseRegViewModel.distance
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("러닝스타일")
                            .customFontStyle(.gray1_B16)
                        // 러닝스타일 설정
                        selectRunningStyle
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("코스제목")
                            .customFontStyle(.gray1_B16)
                        RoundedTextField(text: $courseRegViewModel.title, placeholder: "저장할 러닝 이름을 입력하세요.")
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("코스 소개글")
                            .customFontStyle(.gray1_B16)
                        RoundedTextEditor(text: $courseRegViewModel.content)
                    }
                    
                    HStack {
                        Text("날짜 설정")
                            .customFontStyle(.gray1_B16)
                        Spacer()
                        datePreview
                    }
                    
                    HStack {
                        Text("예상 소요시간")
                            .customFontStyle(.gray1_B16)
                        Spacer()
                        timePreview
                    }
                    
                    HStack {
                        Text("인원 설정")
                            .customFontStyle(.gray1_B16)
                        Spacer()
                        peoplePreview
                    }
                    
                }.padding(.horizontal, 16)
                    .padding(.vertical, 20)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            MainButton(active: isTextFieldValid && !courseRegViewModel.isLoading ,buttonText: "코스 등록하기") {
                courseRegViewModel.uploadCourseData { result in
                    switch result {
                    case .success(let course):
                        router.popScreens(count: 2)
                        router.push(.courseDetail(course))
                    case .failure(let error):
                        print(error)
                    }
                }
            }.padding(.horizontal, 16)
            
        }
        .sheet(isPresented: $isDatePickerPresented,onDismiss: {
            
        }, content: {
            CustomDatePicker(selectedDate: $courseRegViewModel.selectedDate, isPickerPresented: $isDatePickerPresented)
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.hidden)
        })
        .sheet(isPresented: $isTimePickerPresented,onDismiss: {
            
        }, content: {
            TimePicker(hours: $courseRegViewModel.hours, minutes: $courseRegViewModel.minutes, seconds: $courseRegViewModel.seconds, pickerPresented: $isTimePickerPresented)
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.hidden)
                .onChange(of: [courseRegViewModel.hours, courseRegViewModel.minutes, courseRegViewModel.seconds]) { _ in
                    let hoursInSeconds = courseRegViewModel.hours * 3600
                    let minutesInSeconds = courseRegViewModel.minutes * 60
                    let seconds = courseRegViewModel.seconds
                    courseRegViewModel.estimatedTime = Double(hoursInSeconds) + Double(minutesInSeconds) + Double(seconds)
                }
                .onChange(of: courseRegViewModel.estimatedTime) { _ in
                    courseRegViewModel.matchTimeFormat()
                }
        })
        .customNavigation {
            NavigationText(title: "코스 등록")
        } left: {
            NavigationBackButton()
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .preventGesture()
    }
}

// MARK: - Sub View's
extension CourseRegisterView {
    // 러닝스타일 선택
    var selectRunningStyle: some View {
        HStack {
            ForEach(RunningStyle.allCases, id: \.self) { style in
                let isSelected = courseRegViewModel.style == style
                Text(style.description)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(isSelected ? .main : .white)
                    .foregroundColor(isSelected ? .white : .gray2)
                    .clipShape(Capsule())
                
                    .overlay(
                        Capsule()
                            .stroke(.gray3, lineWidth: isSelected ? 0 : 1)
                    )
                    .onTapGesture {
                        withAnimation {
                            courseRegViewModel.style = style
                        }
                    }
            }
        }
        .onChange(of: courseRegViewModel.style) { _ in
            courseRegViewModel.updateCourseInfo()
        }
    }
    
    var datePreview: some View {
        HStack {
            Text(courseRegViewModel.selectedDate?.formattedString() ?? Date().formattedString())
                .customFontStyle(.gray1_M16)
        }
        .padding(.vertical, 8)
        .frame(width: 120)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray3, lineWidth: 1)
        )
        .onTapGesture {
            isDatePickerPresented.toggle()
        }
    }
    
    var timePreview: some View {
        HStack {
            Text("\(formattedHours):\(formattedMinutess):\(formattedSeconds)")
                .customFontStyle(.gray1_M16)
        }
        .padding(.vertical, 8)
        .frame(width: 120)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray3, lineWidth: 1)
        )
        .onTapGesture {
            isTimePickerPresented.toggle()
        }
    }
    
    var peoplePreview: some View {
        HStack {
            Spacer()
            Button(action: {
                courseRegViewModel.removeParticipants()
            }) {
                Image(systemName: "minus")
                    .foregroundColor(.gray1)
            }
            Spacer()
            Text("\(courseRegViewModel.participants)")
                .customFontStyle(.gray1_M16)
            Spacer()
            Button(action: {
                courseRegViewModel.addParticipants()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.gray1)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .frame(width: 120)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray3, lineWidth: 1)
        )
    }
}
