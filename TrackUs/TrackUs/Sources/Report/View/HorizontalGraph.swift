//
//  HorizontalGraph.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI

struct HorizontalGraph: View {
    @State var selectedBarIndex: Int? = nil
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @ObservedObject var viewModel = ReportViewModel.shared
    
    let maxWidth: CGFloat = 130 // 최대 그래프 넓이
    let distanceLigitValue: Double = 20.0 // 최대 한계 값 거리
    let speedLimitValue: Double = 20.0 // 최대 한계 값 속도
    
    var selectedTab: CircleTab
    @Binding var selectedAge : AvgAge
    @Binding var selectedDate: Date?
    
    var formattedCurrentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.string(from: Date())
    }
    
    // 로그인한 유저의 날짜 확인
    var runningLogForSelectedDate: [Runninglog] {
        guard let selectedDate = selectedDate else { return [] }
        return viewModel.runningLog.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDate) }
    }
    
    // 연령대 유저들의 날짜 확인
    var allUserRunningLogForSelectedDate: [Runninglog] {
        guard let selectedDate = selectedDate else { return [] }
        return viewModel.allUserRunningLog.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack() {
                
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.gray2)
                Text("\(authViewModel.userInfo.username)님") // 사용자의 이름
                    .customFontStyle(.gray1_R12)
                
                Spacer()
            }
            
            HStack {
                
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.main)
                Text("TrackUs \(selectedAge.rawValue)") // 사용자의 나이대
                    .customFontStyle(.gray1_R12)
            }
            .padding(.bottom, 20)
            
            VStack {
                if selectedTab == .day {
                    
                    HStack(spacing: 17) {
                        Text("러닝 거리")
                            .customFontStyle(.gray1_SB15)
                        
                        VStack {
                            DistanceBar(value: totalDistanceForSelectedDate, distanceValue: totalDistanceForSelectedDate) // 사용자 일일 러닝 거리
                                .foregroundColor(.gray2)
                                .padding(.bottom, 10)
                            DistanceBar(value: allUserAverageDistanceForSelectedDate, distanceValue: allUserAverageDistanceForSelectedDate) // 연령대 일일 러닝 거리 평균
                                .foregroundColor(.main)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    HStack(spacing: 17) {
                        Text("러닝 속도")
                            .customFontStyle(.gray1_SB15)
                        
                        VStack {
                            SpeedBar(value: averagePaceForSelectedDate, speedValue: averagePaceForSelectedDate) // 사용자 일일 러닝 속도
                                .foregroundColor(.gray2)
                                .padding(.bottom, 10)
                            SpeedBar(value: allUserAveragePaceForSelectedDate, speedValue: allUserAveragePaceForSelectedDate) // 연령대 일일 러닝 속도 평균
                                .foregroundColor(.main)
                        }
                    }
                } else {
                    
                    HStack(spacing: 17) {
                        Text("러닝 거리")
                            .customFontStyle(.gray1_SB15)
                        
                        VStack {
                            DistanceBar(value: averageDistanceForSelectedMonth, distanceValue: averageDistanceForSelectedMonth) // 사용자 월 평균 러닝 거리
                                .foregroundColor(.gray2)
                                .padding(.bottom, 10)
                            DistanceBar(value: allUserAverageDistanceForSelectedMonth, distanceValue: allUserAverageDistanceForSelectedMonth) // 연령대 일일 러닝 거리 평균
                                .foregroundColor(.main)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    HStack(spacing: 17) {
                        Text("러닝 속도")
                            .customFontStyle(.gray1_SB15)
                        
                        VStack {
                            SpeedBar(value: averagePaceForSelectedMonth, speedValue: averagePaceForSelectedMonth) // 사용자 월 평균 러닝 속도
                                .foregroundColor(.gray2)
                                .padding(.bottom, 10)
                            SpeedBar(value: allUserAveragePaceForSelectedMonth, speedValue: allUserAveragePaceForSelectedMonth) // 연령대 일일 러닝 속도 평균
                                .foregroundColor(.main)
                        }
                    }
                }
            }
            
        }
    }
    
    // 필터링된 데이터에서 거리 값 합산
    var totalDistanceForSelectedDate: Double {
        runningLogForSelectedDate.reduce(0) { $0 + $1.distance }
    }
    
    // 필터링된 데이터에서 평균 페이스 계산
    var averagePaceForSelectedDate: Double {
        guard !runningLogForSelectedDate.isEmpty else {
            return 0.0
        }
        
        let totalPace = runningLogForSelectedDate.reduce(0.0) { $0 + $1.pace }
        return totalPace / Double(runningLogForSelectedDate.count)
    }
    
    // 선택된 월의 러닝 데이터 필터링하여 평균 킬로미터 계산
    var averageDistanceForSelectedMonth: Double {
        let runningLogForSelectedMonth = viewModel.runningLog.filter { Calendar.current.isDate($0.timestamp, equalTo: firstDayOfSelectedMonth, toGranularity: .month) }
        
        guard !runningLogForSelectedMonth.isEmpty else {
            return 0.0
        }
        
        let totalDistance = runningLogForSelectedMonth.reduce(0.0) { $0 + $1.distance }
        return totalDistance / Double(runningLogForSelectedMonth.count)
    }
    
    // 선택된 월의 러닝 데이터 필터링하여 평균 페이스 계산
    var averagePaceForSelectedMonth: Double {
        let runningLogForSelectedMonth = viewModel.runningLog.filter { Calendar.current.isDate($0.timestamp, equalTo: firstDayOfSelectedMonth, toGranularity: .month) }
        
        guard !runningLogForSelectedMonth.isEmpty else {
            return 0.0
        }
        
        let totalPace = runningLogForSelectedMonth.reduce(0.0) { $0 + $1.pace }
        return totalPace / Double(runningLogForSelectedMonth.count)
    }
    
    // 연령대별 모든 유저
    // 필터링된 데이터에서 평균 distance와 pace 계산
    // 일별 거리
    var allUserAverageDistanceForSelectedDate: Double {
        guard !allUserRunningLogForSelectedDate.isEmpty else {
            return 0.0
        }
        
        let totalDistance = allUserRunningLogForSelectedDate.reduce(0.0) { $0 + $1.distance }
        return totalDistance / Double(allUserRunningLogForSelectedDate.count)
    }
    
    var allUserAveragePaceForSelectedDate: Double {
        guard !allUserRunningLogForSelectedDate.isEmpty else {
            return 0.0
        }
        
        let totalPace = allUserRunningLogForSelectedDate.reduce(0.0) { $0 + $1.pace }
        let averagePace = totalPace / Double(allUserRunningLogForSelectedDate.count)
        
        return averagePace.isNaN ? 0.0 : averagePace
    }
    
    // 월별 페이스
    var allUserAveragePaceForSelectedMonth: Double {
            let runningLogForSelectedMonth = viewModel.allUserRunningLog.filter { Calendar.current.isDate($0.timestamp, equalTo: firstDayOfSelectedMonth, toGranularity: .month) }
            
            // 수정된 부분: 평균 계산 전에 0 값을 제외합니다.
            let nonZeroPaces = runningLogForSelectedMonth.filter { $0.pace != 0 }
            
            guard !nonZeroPaces.isEmpty else {
                return 0.0
            }
            
            let totalPace = nonZeroPaces.reduce(0.0) { $0 + $1.pace }
            let averagePace = totalPace / Double(nonZeroPaces.count)
            
            return averagePace.isNaN ? 0.0 : averagePace
        }
    
    // 월별 거리
    var allUserAverageDistanceForSelectedMonth: Double {
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
}

struct SpeedBar: View {
    var value: Double
    var speedValue: Double
    
    let maxWidth: CGFloat = 130 // 최대 너비
    let minWidth: CGFloat = 10 // 최소 너비
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(width: maxWidth, height: 12)
                        .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0))
                    
                    Capsule()
                        .frame(width: minWidth + CGFloat(max(0, min((value / 10), Double(maxWidth - minWidth)))), height: 15)
//                        .foregroundColor(.blue)
                    
                    Text(speedValue.asString(unit: .pace))
                        .customFontStyle(.gray1_R9)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .offset(x: minWidth + CGFloat(max(0, min((value / 10), Double(maxWidth - minWidth)))) + 5)
                }
            }
        }
    }
}

struct DistanceBar: View {
    var value: Double
    var distanceValue: Double
    
    let maxWidth: CGFloat = 130 // 최대 너비
    let minWidth: CGFloat = 10 // 최소 너비
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(width: maxWidth, height: 12)
                        .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0))
                    
                    Capsule()
                        .frame(width: minWidth + CGFloat(max(0, min((value * 20), Double(maxWidth - minWidth)))), height: 15)
                    
                    Text(distanceValue.asString(unit: .kilometer))
                        .customFontStyle(.gray1_R9)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .offset(x: minWidth + CGFloat(max(0, min((value * 20), Double(maxWidth - minWidth)))) + 5)
                }
            }
        }
    }
}

//#Preview {
//    HorizontalGraph()
//}
