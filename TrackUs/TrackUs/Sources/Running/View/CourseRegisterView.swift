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
    @ObservedObject var courseViewModel: CourseViewModel
    
    @State private var isDatePickerPresented = false
    @State private var isTimePickerPresented = false
    @State private var isTooltipDisplay = false
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    
    private var isTimeSetting: Bool {
        hours != 0 && minutes != 0 && seconds != 0
    }
    
    private var formattedHours: String {
        String(format: "%02d", isTimeSetting ? hours : courseViewModel.course.estimatedTime.secondsInHours)
    }
    
    private var formattedMinutess: String {
        String(format: "%02d", isTimeSetting ? minutes : courseViewModel.course.estimatedTime.secondsInMinutes)
    }
    
    private var formattedSeconds: String {
        String(format: "%02d", isTimeSetting ? seconds : courseViewModel.course.estimatedTime.seconds)
    }
    
    private var isTextFieldValid: Bool {
        courseViewModel.course.title.count > 0 && courseViewModel.course.content.count > 0
    }
    
    private var buttonEnabled: Bool {
        isTextFieldValid && !courseViewModel.isLoading
    }
    
    private var isEditMode: Bool {
        courseViewModel.course.isEdit
    }
    
    private var buttonText: String {
        isEditMode ? "코스 수정하기" : "코스 등록하기"
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
                    coordinates: courseViewModel.course.coordinates
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
                            estimatedTime: courseViewModel.course.estimatedTime,
                            calories: courseViewModel.course.estimatedCalorie,
                            distance: courseViewModel.course.distance
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
                        RoundedTextField(text: $courseViewModel.course.title, placeholder: "저장할 러닝 이름을 입력하세요.")
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("코스 소개글")
                            .customFontStyle(.gray1_B16)
                        RoundedTextEditor(text: $courseViewModel.course.content)
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
            
            MainButton(active: buttonEnabled ,buttonText: buttonText) {
                if isEditMode {
                    courseViewModel.editCourse { result in
                        switch result {
                        case .success(let course):
                            router.pushOverRootView(.courseDetail(CourseViewModel(course: course)))
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    courseViewModel.addCourse { result in
                        switch result {
                        case .success(let course):
                            router.pushOverRootView(.courseDetail(CourseViewModel(course: course)))
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }.padding(.horizontal, 16)
            
        }
        .sheet(isPresented: $isDatePickerPresented,onDismiss: {
            
        }, content: {
            CustomDatePicker(
                selectedDate: $courseViewModel.course.startDate,
                isPickerPresented: $isDatePickerPresented
            )
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.hidden)
        })
        .sheet(isPresented: $isTimePickerPresented,onDismiss: {
            
        }, content: {
            TimePicker(
                hours: $hours,
                minutes: $minutes,
                seconds: $seconds,
                pickerPresented: $isTimePickerPresented
            )
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.hidden)
                .onChange(of: [hours, minutes, seconds]) { _ in
                    let hoursInSeconds = hours * 3600
                    let minutesInSeconds = minutes * 60
                    let seconds = seconds
                    
                    courseViewModel.course.estimatedTime = Double(hoursInSeconds) + Double(minutesInSeconds) + Double(seconds)
                }
                .onChange(of: courseViewModel.course.estimatedTime) { _ in
                    
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
                let isSelected = courseViewModel.course.runningStyle == style.rawValue
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
                            courseViewModel.course.runningStyle = style.rawValue
                        }
                    }
            }
        }
        .onChange(of: courseViewModel.course.runningStyle) { _ in
            courseViewModel.updateInfoWithPath()
        }
    }
    
    var datePreview: some View {
        HStack {
            Text(courseViewModel.course.startDate?.formattedString() ?? Date().formattedString())
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
                courseViewModel.decreasePeople()
            }) {
                Image(systemName: "minus")
                    .foregroundColor(.gray1)
            }
            Spacer()
            Text("\(courseViewModel.course.numberOfPeople)")
                .customFontStyle(.gray1_M16)
            Spacer()
            Button(action: {
                courseViewModel.increasePeople()
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
