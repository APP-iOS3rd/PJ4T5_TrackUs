//
//  CourseRegisterView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import SwiftUI

struct CourseRegisterView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var courseRegViewModel: CourseRegViewModel
    @State var isDatePickerPresented = false
    @State var isTimePickerPresented = false
    @State var isTooltipDisplay = false
    
    var formattedHours: String {
        String(format: "%02d", courseRegViewModel.hours)
    }
    
    var formattedMinutess: String {
        String(format: "%02d", courseRegViewModel.minutes)
    }
    
    var formattedSeconds: String {
        String(format: "%02d", courseRegViewModel.seconds)
    }
    
    var isTextFieldValid: Bool {
        courseRegViewModel.title.count > 0 && courseRegViewModel.content.count > 0
    }
}

// MARK: - View
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
                        RunningStatsView(estimatedTime: Double(courseRegViewModel.estimatedTime), calories: courseRegViewModel.estimatedCalorie, distance: courseRegViewModel.coorinates.caculateTotalDistance())
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("러닝스타일")
                            .customFontStyle(.gray1_B16)
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
                        participantsPreview
                    }
                    
                }.padding(.horizontal, 16)
                    .padding(.vertical, 20)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            MainButton(active: isTextFieldValid && !courseRegViewModel.isLoading ,buttonText: "코스 등록하기") {
                print(courseRegViewModel.isLoading)
                courseRegViewModel.uploadCourseData { uploadedData in
                    guard let uploadedData = uploadedData else { return }
                    router.popScreens(count: 2)
                    router.push(.courseDetail(uploadedData))
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
            TimePicker(hours: $courseRegViewModel.hours, minutes: $courseRegViewModel.minutes, seconds: $courseRegViewModel.seconds)
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.hidden)
                .onChange(of: [courseRegViewModel.hours, courseRegViewModel.minutes, courseRegViewModel.seconds]) { _ in
                    let hoursInSeconds = courseRegViewModel.hours * 3600
                    let minutesInSeconds = courseRegViewModel.minutes * 60
                    let seconds = courseRegViewModel.seconds
                    courseRegViewModel.estimatedTime = Double(hoursInSeconds) + Double(minutesInSeconds) + Double(seconds)
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
                        courseRegViewModel.style = style
                    }
                
            }
        }
        .onChange(of: courseRegViewModel.style) { _ in
            
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
    
    var participantsPreview: some View {
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


//#Preview {
//    CourseRegisterView()
//}
