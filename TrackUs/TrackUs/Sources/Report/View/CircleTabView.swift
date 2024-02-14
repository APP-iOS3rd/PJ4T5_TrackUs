//
//  CircleView.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI

enum CircleTab: String, CaseIterable {
    case day = "일"
    case month = "월"
}

//MARK: - 일, 월 선택지 및 캘린더

struct CircleTabView: View {
    @Binding var selectedPicker: CircleTab
    @State private var isPickerPresented = false
    @Namespace private var animation
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                animate()
                
                Button {
                    isPickerPresented.toggle()
                } label: {
                    Image("Calendar")
                    
                }
                .padding()
                .offset(y: -15)
                
            }
            CircleSelectView(selectedPicker: $selectedPicker, selectedDate: $selectedDate)
        }
        .sheet(isPresented: $isPickerPresented,onDismiss: {
            
        }, content: {
            if selectedPicker == .day {
                CustomDatePicker(selectedDate: $selectedDate, isPickerPresented: $isPickerPresented)
                    .presentationDetents([.height(400)])
                    .presentationDragIndicator(.hidden)
            } else {
                MonthPicker(isPickerPresented: $isPickerPresented, selectedDate: $selectedDate)
                    .presentationDetents([.height(300)])
                    .presentationDragIndicator(.hidden)
            }
        })
    }
    
    @ViewBuilder
    private func animate() -> some View {
        HStack {
            ForEach(CircleTab.allCases, id: \.self) { item in
                ZStack {
                    if selectedPicker == item {
                        Capsule()
                            .foregroundColor(.main)
                            .frame(height: 30)
                            .matchedGeometryEffect(id: "일별", in: animation)
                    }
                    
                    Text(item.rawValue)
                        .frame(maxWidth: .infinity / 2)
                        .frame(height: 30)
                        .customFontStyle(selectedPicker == item ? .white_M14 : .gray2_L14)
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
        .overlay(
            Capsule()
                .stroke(lineWidth: 2)
                .foregroundStyle(.gray.opacity(0.2))
        )
        .padding(.horizontal, 89)
        .padding(.bottom, 23)
    }
}

struct CircleSelectView: View {
    @Binding var selectedPicker: CircleTab
    @Binding var selectedDate: Date?
    
    var body: some View {
        switch selectedPicker {
        case .day:
            DailyCircleView(selectedDate: $selectedDate)
        case .month:
            MonthlyCircleView(selectedDate: $selectedDate)
        }
    }
}

//MARK: - 일일 운동량 원 그래프

struct DailyCircleView: View {
    @State private var progress: CGFloat = 0.5
    @Binding var selectedDate: Date?
    
    // 어제 날짜로 설정
    private var yesterdayDate: Date {
        if let selectedDate = selectedDate {
            return Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
        } else {
            return Date()
        }
    }
    
    // 내일 날짜로 설정
    private var tomorrowDate: Date {
        if let selectedDate = selectedDate {
            return Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
        } else {
            return Date()
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    selectedDate = yesterdayDate
                } label: {
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundColor(.gray2)
                }
                
                Text(formattedDate)
                    .customFontStyle(.gray1_B20)
                    .padding(.horizontal, 10)
                
                Button {
                    selectedDate = tomorrowDate
                } label: {
                    Image(systemName: "arrowtriangle.right.fill")
                        .foregroundColor(.gray2)
                }
            }
            .padding(.bottom, 30)
            
            ZStack {
                CircularProgressView(progress: progress)
                    .padding(.horizontal, 96)
                
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Text("목표 거리량")
                            .customFontStyle(.blue1_B12)
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .frame(width: 13, height: 13)
                            .foregroundColor(.blue1)
                    }
                    Text("3.2Km / 5Km")
                        .customFontStyle(.gray1_H17)
                        .italic()
                }
            }
            
            HStack {
                VStack(spacing: 7) {
                    Text("151")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("칼로리")
                        .customFontStyle(.gray2_R15)
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("3.2km")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("킬로미터")
                        .customFontStyle(.gray2_R15)
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("00:32")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("시간")
                        .customFontStyle(.gray2_R15)
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("_'__'")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("평균 페이스")
                        .customFontStyle(.gray2_R15)
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 30)
        }
    }
    
    var formattedDate: String {
        guard let selectedDate = selectedDate else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        return dateFormatter.string(from: selectedDate)
    }
    func currentMonthAndYearAndDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        return dateFormatter.string(from: currentDate)
    }
}

//MARK: - 한달 운동량 원 그래프

struct MonthlyCircleView: View {
    @State private var progress: CGFloat = 0.5
    @Binding var selectedDate: Date?
    
    // 어제 날짜로 설정
    private var lastMonthDate: Date {
        if let selectedDate = selectedDate {
            return Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
        } else {
            return Date()
        }
    }
    
    // 내일 날짜로 설정
    private var nextMonthDate: Date {
        if let selectedDate = selectedDate {
            return Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
        } else {
            return Date()
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    selectedDate = lastMonthDate
                } label: {
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundColor(.gray2)
                }
                
                Text(formattedDate)
                    .customFontStyle(.gray1_B20)
                    .padding(.horizontal, 27)
                
                Button {
                    selectedDate = nextMonthDate
                } label: {
                    Image(systemName: "arrowtriangle.right.fill")
                        .foregroundColor(.gray2)
                }
            }
            .padding(.bottom, 30)
            
            ZStack {
                CircularProgressView(progress: progress)
                    .padding(.horizontal, 96)
                
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Text("목표 거리량")
                            .customFontStyle(.blue1_B12)
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .frame(width: 13, height: 13)
                            .foregroundColor(.blue1)
                    }
                    Text("3.2Km / 5Km")
                        .customFontStyle(.gray1_H17)
                        .italic()
                }
            }
            
            HStack {
                VStack(spacing: 7) {
                    Text("151")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("칼로리")
                        .customFontStyle(.gray2_R15)
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("3.2km")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("킬로미터")
                        .customFontStyle(.gray2_R15)
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("00:32")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("시간")
                        .customFontStyle(.gray2_R15)
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("_'__'")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("평균 페이스")
                        .customFontStyle(.gray2_R15)
                }
                
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 30)
        }
    }
    var formattedDate: String {
        guard let selectedDate = selectedDate else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter.string(from: selectedDate)
    }
    
    func currentMonthAndYear() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter.string(from: currentDate)
    }
}

//MARK: - 원 그래프

struct CircularProgressView: View {
    var progress: CGFloat
    @State private var animatedProgress: CGFloat = 0.0 // 애니메이션을 위한
    
    var body: some View {
        ZStack {
            // 원형 트랙
            Circle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 12.0, lineCap: .round))
                .overlay(
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(.gray.opacity(0.2))
                        .padding(7)
                )
                .overlay(
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(.gray.opacity(0.2))
                        .padding(-7)
                )
            
            // 원형 그래프
            Circle()
                .trim(from: 0.0, to: animatedProgress)
                .stroke(LinearGradient(gradient: Gradient(colors: [Color.main, Color.main.opacity(0.2)]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 13.0, lineCap: .round))
                .rotationEffect(Angle(degrees: 90))
                .onAppear {
                    // 애니메이션 적용
                    withAnimation(.easeInOut(duration: 0.65)) {
                        animatedProgress = progress
                    }
                }
        }
    }
}

//#Preview {
////    CircleView()
//    CircleTabView()
////    MonthlyCircleView()
//}
