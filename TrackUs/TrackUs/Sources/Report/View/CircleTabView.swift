//
//  CircleView.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI
import Combine

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
    @Binding var selectedDate: Date?
    
    @ObservedObject var viewModel = ReportViewModel.shared
    @StateObject var authViewModel = AuthenticationViewModel.shared
    
    var runningLogForSelectedDate: [Runninglog] {
        guard let selectedDate = selectedDate else { return [] }
        return viewModel.runningLog.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDate) }
    }
    
    var progressValue: CGFloat {
        guard let dailyGoal = authViewModel.userInfo.setDailyGoal else { return 0.5 } // 기본값
        
        let distanceInKm = totalDistanceForSelectedDate / 1000.0 // 러닝 데이터의 총 거리 (km)
        let progressPercentage = min(distanceInKm / dailyGoal, 1.0) // 진행률 (0.0 ~ 1.0)
        
        return CGFloat(progressPercentage)
    }
    
    
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
                CircularProgressView(selectedDate: selectedDate, progress: progressValue)
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
                    Text("\(String(format: "%.1f", totalDistanceForSelectedDate / 1000.0) + "km") / \(String(format: "%.1f", authViewModel.userInfo.setDailyGoal ?? 0) + "km")")
                        .customFontStyle(.gray1_H17)
                        .italic()
                }
            }
            
            HStack {
                VStack(spacing: 7) {
                    Text(String(format: "%.1f", totalCaloriesForSelectedDate))
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("칼로리")
                        .customFontStyle(.gray2_R15)
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text(String(format: "%.2f", totalDistanceForSelectedDate / 1000.0) + "km")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("킬로미터")
                        .customFontStyle(.gray2_R15)
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("\(totalTimeForSelectedDate.asString(style: .positional))")
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
            .padding(.horizontal, 30)
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
    
    // 필터링된 데이터에서 칼로리 값 합산
    var totalCaloriesForSelectedDate: Double {
        runningLogForSelectedDate.reduce(0) { $0 + $1.calorie }
    }
    
    // 필터링된 데이터에서 거리 값 합산
    var totalDistanceForSelectedDate: Double {
        runningLogForSelectedDate.reduce(0) { $0 + $1.distance }
    }
    
    // 필터링된 데이터에서 시간 값 합산
    var totalTimeForSelectedDate: Double {
        Double(runningLogForSelectedDate.reduce(0) { $0 + $1.elapsedTime })
    }
    
    // 필터링된 데이터에서 평균 페이스 계산
    var averagePaceForSelectedDate: Double {
        guard !runningLogForSelectedDate.isEmpty else {
            return 0.0
        }
        
        let totalPace = runningLogForSelectedDate.reduce(0.0) { $0 + $1.pace }
        return totalPace / Double(runningLogForSelectedDate.count)
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
    @Binding var selectedDate: Date?
    
    @ObservedObject var viewModel = ReportViewModel.shared
    @StateObject var authViewModel = AuthenticationViewModel.shared
    
    var progressValue: CGFloat {
        guard let dailyGoal = authViewModel.userInfo.setDailyGoal else { return 0.5 } // 기본값
        
        let distanceInKm = averageDistanceForSelectedMonth / 1000.0 // 러닝 데이터의 총 거리 (km)
        let progressPercentage = min(distanceInKm / dailyGoal, 1.0) // 진행률 (0.0 ~ 1.0)
        
        return CGFloat(progressPercentage)
    }
    
    // 저번달로 설정
    private var lastMonthDate: Date {
        if let selectedDate = selectedDate {
            return Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
        } else {
            return Date()
        }
    }
    
    // 다음달로 설정
    private var nextMonthDate: Date {
        if let selectedDate = selectedDate {
            return Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
        } else {
            return Date()
        }
    }
    
    // 이번 달 첫 번째 날짜
    private var firstDayOfSelectedMonth: Date {
        if let selectedDate = selectedDate {
            return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate)) ?? Date()
        } else {
            return Date()
        }
    }
    
    // 다음 달 첫 번째 날짜
    private var firstDayOfNextMonth: Date {
        if let selectedDate = selectedDate {
            return Calendar.current.date(byAdding: .month, value: 1, to: firstDayOfSelectedMonth) ?? Date()
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
                CircularProgressView(selectedDate: selectedDate, progress: progressValue)
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
                    Text("\(String(format: "%.1f", averageDistanceForSelectedMonth / 1000.0) + "km") / \(String(format: "%.1f", authViewModel.userInfo.setDailyGoal ?? 0) + "km")")
                        .customFontStyle(.gray1_H17)
                        .italic()
                }
            }
            
            HStack {
                VStack(spacing: 7) {
                    Text(String(format: "%.1f", averageCaloriesForSelectedMonth))
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("칼로리")
                        .customFontStyle(.gray2_R15)
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text(String(format: "%.2f", averageDistanceForSelectedMonth / 1000.0) + "km")
                        .customFontStyle(.gray1_B20)
                        .italic()
                    Text("킬로미터")
                        .customFontStyle(.gray2_R15)
                }
                
                Spacer()
                
                VStack(spacing: 7) {
                    Text("\(averageTimeForSelectedMonth.asString(style: .positional))")
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
            .padding(.horizontal, 30)
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
    
    // 선택된 월의 러닝 데이터 필터링하여 평균 칼로리 계산
    var averageCaloriesForSelectedMonth: Double {
        let runningLogForSelectedMonth = viewModel.runningLog.filter { Calendar.current.isDate($0.timestamp, equalTo: firstDayOfSelectedMonth, toGranularity: .month) }
        
        // 러닝 데이터가 없는 경우 평균 칼로리를 0으로 설정하거나 다른 처리를 수행
        guard !runningLogForSelectedMonth.isEmpty else {
            return 0
        }
        
        let totalCalories = runningLogForSelectedMonth.reduce(0) { $0 + $1.calorie }
        return totalCalories / Double(runningLogForSelectedMonth.count)
    }
    
    // 선택된 월의 러닝 데이터 필터링하여 평균 킬로미터 계산
    var averageDistanceForSelectedMonth: Double {
        let runningLogForSelectedMonth = viewModel.runningLog.filter { Calendar.current.isDate($0.timestamp, equalTo: firstDayOfSelectedMonth, toGranularity: .month) }
        
        guard !runningLogForSelectedMonth.isEmpty else {
            return 0.0 // 러닝 데이터가 없는 경우 평균 킬로미터를 0.0으로 설정하거나 다른 처리를 수행
        }
        
        let totalDistance = runningLogForSelectedMonth.reduce(0.0) { $0 + $1.distance }
        return totalDistance / Double(runningLogForSelectedMonth.count)
    }
    
    // 선택된 월의 러닝 데이터 필터링하여 평균 시간 계산
    var averageTimeForSelectedMonth: Double {
        let runningLogForSelectedMonth = viewModel.runningLog.filter { Calendar.current.isDate($0.timestamp, equalTo: firstDayOfSelectedMonth, toGranularity: .month) }
        
        guard !runningLogForSelectedMonth.isEmpty else {
            return 0 // 러닝 데이터가 없는 경우 평균 시간을 0으로 설정하거나 다른 처리를 수행
        }
        
        let totalTime = runningLogForSelectedMonth.reduce(0) { $0 + $1.elapsedTime }
        return Double(totalTime / runningLogForSelectedMonth.count)
    }
    
    // 선택된 월의 러닝 데이터 필터링하여 평균 페이스 계산
    var averagePaceForSelectedMonth: Double {
        let runningLogForSelectedMonth = viewModel.runningLog.filter { Calendar.current.isDate($0.timestamp, equalTo: firstDayOfSelectedMonth, toGranularity: .month) }
        
        guard !runningLogForSelectedMonth.isEmpty else {
            return 0.0 // 러닝 데이터가 없는 경우 평균 페이스를 0.0으로 설정하거나 다른 처리를 수행
        }
        
        let totalPace = runningLogForSelectedMonth.reduce(0.0) { $0 + $1.pace }
        return totalPace / Double(runningLogForSelectedMonth.count)
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
    var selectedDate: Date?  // selectedDate 추가
    var progress: CGFloat
    
    @State private var animatedProgress: CGFloat = 0.0 // 애니메이션을 위한
    
    var body: some View {
        // 선택된 날짜에 따라 진행률을 계산
        
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
                    withAnimation {
                        animatedProgress = progress
                    }
                }
                .id(selectedDate) // selectedDate의 변경을 감지하기 위해 id 추가
        }
    }
}

// 일일 운동량
struct RunningSummary {
    let calorie: Double
    let distance: Double
    let elapsedTime: Int
    let pace: Double
}

//#Preview {
////    CircleView()
//    CircleTabView()
////    MonthlyCircleView()
//}
