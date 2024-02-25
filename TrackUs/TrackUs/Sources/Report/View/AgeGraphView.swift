//
//  AgeGraphView.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI

enum AvgAge: String, CaseIterable, Identifiable { // 나이대 피커
    case teens = "10대"
    case twenties = "20대"
    case thirties = "30대"
    case forties = "40대"
    case fifties = "50대"
    case sixties = "60대"
    
    var id: Self { self }
    
    var intValue: Int {
        switch self {
        case .teens: return 10
        case .twenties: return 20
        case .thirties: return 30
        case .forties: return 40
        case .fifties: return 50
        case .sixties: return 60
            
        }
    }
}

//MARK: - 연령대 추세 비교 가로 그래프, 바 그래프

struct AgeGraphView: View {
    var selectedTab: CircleTab
    @State private var isPickerPresented = false
    //    @State var selectedAge : AvgAge = .twenties
    @Binding var selectedAge : AvgAge
    @Binding var selectedDate: Date?
    @ObservedObject var viewModel = ReportViewModel.shared
    
    // 사용자
    var runningLogForSelectedDate: [Runninglog] {
        guard let selectedDate = selectedDate else { return [] }
        return viewModel.runningLog.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDate) }
    }
//    var runningLogForSelectedDate: [UserRunningLog] {
//        guard let selectedDate = selectedDate else { return [] }
//        return viewModel.runningLog.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDate) }
//    }
    
    // 연령대
    var allUserRunningLogForSelectedDate: [Runninglog] {
        guard let selectedDate = selectedDate else { return [] }
        return viewModel.allUserRunningLog.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDate) }
    }
    
    var totalDistanceForSelectedDate: Double { //일일 사용자 거리
        runningLogForSelectedDate.reduce(0) { $0 + $1.distance }
    }
    
    var allUserAverageDistanceForSelectedDate: Double { //일일 연령대 거리
        guard !allUserRunningLogForSelectedDate.isEmpty else {
            return 0.0
        }
        
        let totalDistance = allUserRunningLogForSelectedDate.reduce(0.0) { $0 + $1.distance }
        return totalDistance / Double(allUserRunningLogForSelectedDate.count)
    }
    
    var averageDistanceForSelectedMonth: Double { // 월평균 사용자 거리
        let runningLogForSelectedMonth = viewModel.runningLog.filter { Calendar.current.isDate($0.timestamp, equalTo: firstDayOfSelectedMonth, toGranularity: .month) }
        
        guard !runningLogForSelectedMonth.isEmpty else {
            return 0.0
        }
        
        let totalDistance = runningLogForSelectedMonth.reduce(0.0) { $0 + $1.distance }
        return totalDistance / Double(runningLogForSelectedMonth.count)
    }
    
    var allUserAverageDistanceForSelectedMonth: Double { // 월평균 연령대 거리
        let runningLogForSelectedMonth = viewModel.allUserRunningLog.filter { Calendar.current.isDate($0.timestamp, equalTo: firstDayOfSelectedMonth, toGranularity: .month) }
        
        guard !runningLogForSelectedMonth.isEmpty else {
            return 0.0
        }
        
        let totalDistance = runningLogForSelectedMonth.reduce(0.0) { $0 + $1.distance }
        return totalDistance / Double(runningLogForSelectedMonth.count)
    }
    
    // 이번 달 첫 번째 날짜
    private var firstDayOfSelectedMonth: Date {
        if let selectedDate = selectedDate {
            return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate)) ?? Date()
        } else {
            return Date()
        }
    }
    
    
    
    var body: some View {
        VStack {
            HStack {
                Text("\(selectedTab == .day ? formattedDate : formattedMonth) 운동량")
                    .customFontStyle(.gray1_SB16)
                
                Spacer()
                
                Button {
                    isPickerPresented.toggle()
                } label: {
                    HStack {
                        Text(selectedAge.rawValue)
                            .customFontStyle(.gray1_SB12)
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.gray1)
                    }
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth: 1)
                            .foregroundColor(.gray1)
                    )
                    .onChange(of: selectedAge) { newValue in
                        DispatchQueue.main.async {
                            viewModel.userAge = newValue.intValue
                            viewModel.fetchUserAgeLog(selectedDate: selectedDate!)
                        }
                    }
                }
            }
            
            if selectedTab == .day {
                HStack(spacing: 3) {
                    Text("동일 연령대의 TrackUs 회원 중").customFontStyle(.gray2_R12)
                    Text("상위").customFontStyle(.gray2_R12)
                    Text(String(format: "%.1f%%", dayCalculateUserPercentage())).customFontStyle(.gray1_R12).bold()
                    Text("(운동량 기준)").customFontStyle(.gray2_R12)
                    
                    Spacer()
                }
            } else {
                HStack(spacing: 3) {
                    Text("동일 연령대의 TrackUs 회원 중").customFontStyle(.gray2_R12)
                    Text("상위").customFontStyle(.gray2_R12)
                    Text(String(format: "%.1f%%", monthCalculateUserPercentage())).customFontStyle(.gray1_R12).bold()
                    Text("(운동량 기준)").customFontStyle(.gray2_R12)
                    
                    Spacer()
                }
            }
            
            // 가로 그래프
            HorizontalGraph(selectedTab: selectedTab, selectedAge: $selectedAge, selectedDate: $selectedDate)
                .padding(.top, 14)
                .padding(.bottom, 40)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("평균 운동량 추세")
                        .customFontStyle(.gray1_SB16)
                        .padding(.bottom, 5)
                    Text("그래프를 터치하여 월별 피드백을 확인해보세요.")
                        .customFontStyle(.gray2_R12)
                }
                
                Spacer()
            }
            
            if selectedTab == .day {
                WeakGraphView(selectedAge: $selectedAge, selectedDate: $selectedDate)
                    .padding(.top, 14)
                    .padding(.bottom, 40)
            } else {
                BarGraphView(selectedAge: $selectedAge, selectedDate: $selectedDate)
                    .padding(.top, 14)
                    .padding(.bottom, 40)
            }
            
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: $isPickerPresented,onDismiss: {
            
        }, content: {
            filterPicker(selectedAge: $selectedAge, isPickerPresented: $isPickerPresented)
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.hidden)
        })
    }
    
    var formattedDate: String {
        guard let selectedDate = selectedDate else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: selectedDate)
    }
    
    var formattedMonth: String {
        guard let selectedDate = selectedDate else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " M월"
        return dateFormatter.string(from: selectedDate)
    }
    
    func dayCalculateUserPercentage() -> Double {
        guard let selectedDate = selectedDate else {
            return 0.0
        }
        
        let allUserAverageDistance = totalDistanceForSelectedDate
        let userAverageDistance = allUserAverageDistanceForSelectedDate
        
        if allUserAverageDistance > 0 {
            let percentage = min(100, (userAverageDistance / allUserAverageDistance) * 100)
            return max(0, percentage)
        } else {
            return 0.0
        }
    }
    
    func monthCalculateUserPercentage() -> Double {
        guard let selectedDate = selectedDate else {
            return 0.0
        }
        
        let allUserAverageDistance = allUserAverageDistanceForSelectedMonth
        let userAverageDistance = averageDistanceForSelectedMonth
        
        if allUserAverageDistance > 0 {
            let percentage = min(100, (userAverageDistance / allUserAverageDistance) * 100)
            return max(0, percentage)
        } else {
            return 0.0
        }
    }
}

struct filterPicker: View {
    @Binding var selectedAge: AvgAge
    @Binding var isPickerPresented: Bool
    
    var body: some View {
        VStack {
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    isPickerPresented.toggle()
                }, label: {
                    Text("확인")
                        .customFontStyle(.main_SB16)
                        .padding(25)
                })
            }
            
            
            Picker("", selection: $selectedAge) {
                ForEach(AvgAge.allCases, id: \.self) { age in
                    Text(age.rawValue).tag(age)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding(.horizontal, 50)
            
        }
    }
}

//#Preview {
//    AgeGraphView(selectedTab: .day)
//}
