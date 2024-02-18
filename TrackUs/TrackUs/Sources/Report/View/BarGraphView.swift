//
//  BarGraphView.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI
import Charts


//MARK: - 월별 그래프

struct BarGraphView: View {
    @State var selectedBarIndex: Int?
    @State var avg = 20
    @Binding var selectedAge : AvgAge
    @ObservedObject var viewModel = ReportViewModel.shared
    @Binding var selectedDate: Date?
    
    @State private var monthAgeAvgData : [AgeMonthAvg] = [
        AgeMonthAvg(month: "Jan", data: 0),
        AgeMonthAvg(month: "Feb", data: 0),
        AgeMonthAvg(month: "Mar", data: 0),
        AgeMonthAvg(month: "Apr", data: 0),
        AgeMonthAvg(month: "May", data: 0),
        AgeMonthAvg(month: "Jun", data: 0),
        AgeMonthAvg(month: "Jul", data: 0),
        AgeMonthAvg(month: "Aug", data: 0),
        AgeMonthAvg(month: "Sep", data: 0),
        AgeMonthAvg(month: "Oct", data: 0),
        AgeMonthAvg(month: "Nov", data: 0),
        AgeMonthAvg(month: "Dec", data: 0)
    ]
    
    @State private var monthMyAvgData : [AgeMonthAvg] = [
        AgeMonthAvg(month: "Jan", data: 0),
        AgeMonthAvg(month: "Feb", data: 0),
        AgeMonthAvg(month: "Mar", data: 0),
        AgeMonthAvg(month: "Apr", data: 0),
        AgeMonthAvg(month: "May", data: 0),
        AgeMonthAvg(month: "Jun", data: 0),
        AgeMonthAvg(month: "Jul", data: 0),
        AgeMonthAvg(month: "Aug", data: 0),
        AgeMonthAvg(month: "Sep", data: 0),
        AgeMonthAvg(month: "Oct", data: 0),
        AgeMonthAvg(month: "Nov", data: 0),
        AgeMonthAvg(month: "Dec", data: 0)
    ]
    
    var body: some View {
        VStack {
            
            Spacer()
            ZStack(alignment: .bottom) {
                Chart {
                    ForEach(monthAgeAvgData) { item in
                        LineMark(x: .value("Month", item.month), y: .value("Data", item.data))
                            .symbol {
                                Circle()
                                    .frame(width: 5)
                            }
                    }
                }
                .frame(maxWidth: 310)
                .frame(height: 100)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .offset(y: -30)
                
                HStack(alignment: .bottom) {
                    ForEach(monthMyAvgData.indices, id: \.self) { index in
                        let avgData = monthMyAvgData[index]
                        ZStack {
                            VStack {
                                BarView(value: CGFloat(avgData.data), isSelected: selectedBarIndex == index, selectedDate: $selectedDate).padding(.horizontal, 3)
                                Text(avgData.month) // 요일 데이터 표시
                                    .customFontStyle(.gray4_R9)
                                    .fontWeight(selectedBarIndex == index ? .bold : .regular)
                            }
                            .onTapGesture {
                                if selectedBarIndex == index {
                                    selectedBarIndex = nil // 중복 선택 방지
                                } else {
                                    selectedBarIndex = index
                                }
                            }
                            
                            if selectedBarIndex == index {
                                Text("\(avgData.data / 1000, specifier: "%.1f")km")
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(3)
                                    .background(Color.main)
                                    .cornerRadius(23)
                                    .offset(y: -100)
                                    .padding(.horizontal, -15)
                            }
                        }
                    }
                }
                
            }
            
            VStack {
                if let selectedBarIndex = selectedBarIndex {
                    let selectedMonth = monthMyAvgData[selectedBarIndex]
                    let monthString = "\(selectedBarIndex + 1)월"
                    
                    Text("회원님의 \(monthString) 운동량은 \(selectedAge.rawValue) 평균보다") +
                    
                    Text(" \(calculatePercentageIncreaseMonth(), specifier: "%.1f")% ").bold().foregroundColor(.main) +
                    
                    Text("\(calculatePercentageIncreaseMonth() > 0 ? "높으며" : "낮으며") 전달 대비 운동횟수가 ") +
                    
                    Text("\(abs(calculateChangeInDataCount()))회 \(calculateChangeInDataCount() >= 0 ? "증가" : "감소") ").bold().foregroundColor(.main) +
                    
                    Text("했습니다.")
                } else {
                    if let selectedDate = selectedDate {
                        let calendar = Calendar.current
                        let currentMonth = calendar.component(.month, from: selectedDate)
                        let monthString = "\(currentMonth)월"
                        
                        Text("회원님의 \(monthString) 운동량은 \(selectedAge.rawValue) 평균보다") +
                        
                        Text(" \(calculatePercentageIncreaseMonth(), specifier: "%.1f")% ").bold().foregroundColor(.main) +
                        
                        Text("\(calculatePercentageIncreaseMonth() > 0 ? "높으며" : "낮으며") 전달 대비 운동횟수가 ") +
                        
                        Text("\(abs(calculateChangeInDataCount()))회 \(calculateChangeInDataCount() >= 0 ? "증가" : "감소") ").bold().foregroundColor(.main) +
                        
                        Text("했습니다.")
                    }
                }
            }
            .foregroundColor(.gray2)
            .font(.custom("Regular", size: 14))
            .padding(.top, 16)
        }
        .frame(height: 250)
        .onAppear {
            updateMonthMyAvgData()
            updateMonthAgeAvgData()
        }
        .onChange(of: selectedAge) { _ in
            updateMonthMyAvgData()
            updateMonthAgeAvgData()
        }
        .id(selectedDate)
    }
    
    //MARK: - 로그인한 유저의 월별 평균 운동량
    
    private func updateMonthMyAvgData() {
        guard let selectedDate = selectedDate else { return }
        
        let calendar = Calendar.current
        guard let startDateOfYear = calendar.date(from: calendar.dateComponents([.year], from: selectedDate)),
              let endDateOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startDateOfYear) else {
            return
        }
        
        var monthIndex = 0
        var currentDate = startDateOfYear
        
        while currentDate <= endDateOfYear {
            guard let endDateOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: currentDate) else {
                return
            }
            
            let dataForThisMonth = getDataForMonth(startDate: currentDate, endDate: endDateOfMonth)
            let averageDistanceForMonth = dataForThisMonth.reduce(0.0) { $0 + $1.data } / Double(dataForThisMonth.count)
            
            monthMyAvgData[monthIndex].data = averageDistanceForMonth
            
            monthIndex += 1
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
    }
    
    private func getDataForMonth(startDate: Date, endDate: Date) -> [AgeMonthAvg] {
        let runningLogForMonth = viewModel.runningLog.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
        var dataForMonth: [String: Double] = [:]
        let calendar = Calendar.current
        let monthSymbols = calendar.monthSymbols
        
        for month in monthSymbols {
            guard let monthIndex = monthSymbols.firstIndex(of: month) else {
                continue
            }
            let dataForThisMonth = runningLogForMonth.filter {
                calendar.component(.month, from: $0.timestamp) == monthIndex + 1
            }
            
            let totalDistance = dataForThisMonth.reduce(0.0) { $0 + $1.distance }
            dataForMonth[month] = totalDistance
        }
        
        var result: [AgeMonthAvg] = []
        for (month, totalDistance) in dataForMonth {
            result.append(AgeMonthAvg(month: month, data: totalDistance))
        }
        
        return result
    }
    
    //MARK: - 선택한 연령대 유저들의 월별 평균 운동량
    
    private func updateMonthAgeAvgData() {
        guard let selectedDate = selectedDate else { return }
        
        let calendar = Calendar.current
        guard let startDateOfYear = calendar.date(from: calendar.dateComponents([.year], from: selectedDate)),
              let endDateOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startDateOfYear) else {
            return
        }
        
        var monthIndex = 0
        var currentDate = startDateOfYear
        
        while currentDate <= endDateOfYear {
            guard let endDateOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: currentDate) else {
                return
            }
            
            let dataForThisMonth = ageDataForMonth(startDate: currentDate, endDate: endDateOfMonth)
            let averageDistanceForMonth = dataForThisMonth.reduce(0.0) { $0 + $1.data } / Double(dataForThisMonth.count)
            
            monthAgeAvgData[monthIndex].data = averageDistanceForMonth
            
            monthIndex += 1
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
    }
    
    private func ageDataForMonth(startDate: Date, endDate: Date) -> [AgeMonthAvg] {
        let runningLogForMonth = viewModel.allUserRunningLog.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
        var dataForMonth: [String: Double] = [:]
        let calendar = Calendar.current
        let monthSymbols = calendar.monthSymbols
        
        for month in monthSymbols {
            guard let monthIndex = monthSymbols.firstIndex(of: month) else {
                continue
            }
            let dataForThisMonth = runningLogForMonth.filter {
                calendar.component(.month, from: $0.timestamp) == monthIndex + 1
            }
            
            let totalDistance = dataForThisMonth.reduce(0.0) { $0 + $1.distance }
            dataForMonth[month] = totalDistance
        }
        
        var result: [AgeMonthAvg] = []
        for (month, totalDistance) in dataForMonth {
            result.append(AgeMonthAvg(month: month, data: totalDistance))
        }
        
        return result
    }
    
    //MARK: - 월별 백분율
    private func calculatePercentageIncreaseMonth() -> Double {
        // 선택된 월이 있는지 확인합니다.
        if let selectedBarIndex = selectedBarIndex {
            let selectedMonthMyAvgData = monthMyAvgData[selectedBarIndex]
            let selectedMonthAgeAvgData = monthAgeAvgData[selectedBarIndex]
            
            // 선택된 월의 데이터가 모두 0인 경우 0을 반환합니다.
            guard selectedMonthMyAvgData.data != 0 && selectedMonthAgeAvgData.data != 0 else { return 0 }
            
            // 백분율 증가율을 계산합니다.
            let percentageIncrease = ((selectedMonthMyAvgData.data - selectedMonthAgeAvgData.data) / selectedMonthAgeAvgData.data) * 100
            
            return percentageIncrease
        } else if let selectedDate = selectedDate {
            let calendar = Calendar.current
            let currentMonth = calendar.component(.month, from: selectedDate)
            
            // 선택된 월의 데이터가 있는지 확인합니다.
            guard currentMonth <= monthMyAvgData.count && currentMonth <= monthAgeAvgData.count else { return 0 }
            
            let currentMonthMyAvgData = monthMyAvgData[currentMonth - 1]
            let currentMonthAgeAvgData = monthAgeAvgData[currentMonth - 1]
            
            // 현재 월의 데이터가 모두 0인 경우 0을 반환합니다.
            guard currentMonthMyAvgData.data != 0 && currentMonthAgeAvgData.data != 0 else { return 0 }
            
            // 백분율 증가율을 계산합니다.
            let percentageIncrease = ((currentMonthMyAvgData.data - currentMonthAgeAvgData.data) / currentMonthAgeAvgData.data) * 100
            
            return percentageIncrease
        }
        
        return 0
    }
    
    //MARK: - 이전달과 이번달 러닝 횟수
    private func calculateChangeInDataCount() -> Int {
        guard let selectedDate = selectedDate else { return 0 }
        
        let calendar = Calendar.current
        let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: selectedDate)!
        
        let previousMonthDataCount = getDataCount(for: previousMonthDate)
        let currentMonthDataCount = getDataCount(for: selectedDate)
        
        return currentMonthDataCount - previousMonthDataCount
    }
    
    private func getDataCount(for date: Date) -> Int {
        let calendar = Calendar.current
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart)!
        
        let dataForMonth = viewModel.runningLog.filter { $0.timestamp >= monthStart && $0.timestamp <= monthEnd }
        
        return dataForMonth.count
    }
    
}

//MARK: - 일주일 그래프

struct WeakGraphView: View {
    @State private var shouldRefresh = false
    @State var selectedBarIndex: Int?
    @State var avg = 20
    @Binding var selectedAge : AvgAge
    @ObservedObject var viewModel = ReportViewModel.shared
    @Binding var selectedDate: Date?
    
    @State private var weakAgeAvgData : [AgeWeakAvg] = [
        AgeWeakAvg(weak: "Sun", data: 0),
        AgeWeakAvg(weak: "Mon", data: 0),
        AgeWeakAvg(weak: "Tue", data: 0),
        AgeWeakAvg(weak: "Wed", data: 0),
        AgeWeakAvg(weak: "Thu", data: 0),
        AgeWeakAvg(weak: "Fri", data: 0),
        AgeWeakAvg(weak: "Sat", data: 0)
    ]
    
    @State private var LastweakMyAvgData : [AgeWeakAvg] = [
        AgeWeakAvg(weak: "Sun", data: 0),
        AgeWeakAvg(weak: "Mon", data: 0),
        AgeWeakAvg(weak: "Tue", data: 0),
        AgeWeakAvg(weak: "Wed", data: 0),
        AgeWeakAvg(weak: "Thu", data: 0),
        AgeWeakAvg(weak: "Fri", data: 0),
        AgeWeakAvg(weak: "Sat", data: 0)
    ]
    
    @State private var weakMyAvgData : [AgeWeakAvg] = [
        AgeWeakAvg(weak: "Sun", data: 0),
        AgeWeakAvg(weak: "Mon", data: 0),
        AgeWeakAvg(weak: "Tue", data: 0),
        AgeWeakAvg(weak: "Wed", data: 0),
        AgeWeakAvg(weak: "Thu", data: 0),
        AgeWeakAvg(weak: "Fri", data: 0),
        AgeWeakAvg(weak: "Sat", data: 0)
    ]
    
    var body: some View {
        
        if case .loading = viewModel.userLogLoadingState {
            Text("Loading")
        } else {
            
            VStack {
                Spacer()
                ZStack(alignment: .bottom) {
                    Chart {
                        ForEach(weakAgeAvgData) { item in
                            LineMark(x: .value("Weak", item.weak), y: .value("Data", item.data))
                                .symbol {
                                    Circle()
                                        .frame(width: 6)
                                }
                        }
                    }
                    .frame(maxWidth: 280)
                    .frame(height: 100)
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    //                .offset(y: -15)
                    .offset(y: -30)
                    
                    HStack(alignment: .bottom) {
                        ForEach(weakMyAvgData.indices, id: \.self) { index in
                            let avgData = weakMyAvgData[index]
                            ZStack {
                                VStack {
                                    BarView(value: CGFloat(avgData.data), isSelected: selectedBarIndex == index, selectedDate: $selectedDate).padding(.horizontal, 10)
                                    Text(avgData.weak) // 요일 데이터 표시
                                        .customFontStyle(.gray4_R9)
                                        .fontWeight(selectedBarIndex == index ? .bold : .regular)
                                }
                                .onTapGesture {
                                    if selectedBarIndex == index {
                                        selectedBarIndex = nil // 중복 선택 방지
                                    } else {
                                        selectedBarIndex = index
                                    }
                                }
                                
                                if selectedBarIndex == index {
                                    Text("\(avgData.data / 1000, specifier: "%.1f")km")
                                        .font(.system(size: 10))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(3)
                                        .background(Color.main)
                                        .cornerRadius(23)
                                        .offset(y: -100)
                                        .padding(.horizontal, -15)
                                }
                            }
                        }
                    }
                    
                }
                
                let lastWeek = countNonZeroValues(LastweakMyAvgData)
                let currentWeek = countNonZeroValues(weakMyAvgData)
                
                VStack {
                    Text("회원님의 이번주 운동량은 \(selectedAge.rawValue) 평균보다") +
                    Text(" \(calculatePercentageIncreaseWeak(), specifier: "%.1f" )% ").bold().foregroundColor(.main) +
                    Text("\(calculatePercentageIncreaseWeak() > 0 ? "높으며" : "낮으며") 전주 대비 운동횟수가 ") +
                    Text("\(lastWeek > currentWeek ? lastWeek - currentWeek : (currentWeek > lastWeek ? currentWeek - lastWeek : 0))회 \((currentWeek > lastWeek ? "증가" : (lastWeek > currentWeek ? "감소" : "증가")))").bold().foregroundColor(.main) +
                    Text(" 했습니다.")
                }
                .foregroundColor(.gray2)
                .font(.custom("Regular", size: 14))
                .padding(.top, 16)
            }
            .frame(height: 250)
            .onAppear {
                DispatchQueue.main.async {
                    updateWeakMyAvgData()
                    updateWeakAgeAvgData()
                    updateLastWeakMyAvgData()
                }
            }
            .onChange(of: selectedAge) { newValue in
                DispatchQueue.main.async {
                    updateWeakMyAvgData()
                    updateWeakAgeAvgData()
                    updateLastWeakMyAvgData()
                }
            }
            .id(selectedDate)
        }
    }
    
    //MARK: - 로그인한 유저의 일주일 운동량
    private func updateWeakMyAvgData() {
        guard let selectedDate = selectedDate else { return }
        
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)),
              let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) else {
            return
        }
        
        let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: startDate)!
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)!
        
        let dataForThisWeek = getDataForWeek(startDate: startOfDay, endDate: endOfDay)
        
        for (dayIndex, day) in Calendar.current.weekdaySymbols.enumerated() {
            let dataForDay = dataForThisWeek.filter { $0.weak == day }
            if let averageData = dataForDay.first {
                weakMyAvgData[dayIndex].data = averageData.data
            } else {
                weakMyAvgData[dayIndex].data = 0
            }
        }
        
        //                print("Updated weakMyAvgData: \(weakMyAvgData)")
    }
    
    
    private func getDataForWeek(startDate: Date, endDate: Date) -> [AgeWeakAvg] {
        //        print("시작 날짜 \(startDate), 끝 날짜 \(endDate)")
        print("여기서부터 시작!!!!!!!\(viewModel.runningLog) 여기까지가 끝!!!!!!")
        let runningLogForWeek = viewModel.runningLog.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
        var dataForWeek: [String: Double] = [:]
        let calendar = Calendar.current
        let weekDays = calendar.weekdaySymbols
        
        for day in weekDays {
            guard let dayIndex = calendar.weekdaySymbols.firstIndex(of: day) else {
                continue
            }
            let dataForDay = runningLogForWeek.filter {
                calendar.component(.weekday, from: $0.timestamp) == (dayIndex + calendar.firstWeekday - 1) % 7 + 1
            }
            
            let totalDistance = dataForDay.reduce(0.0) { $0 + $1.distance }
            dataForWeek[day] = totalDistance
        }
        
        var result: [AgeWeakAvg] = []
        for (day, totalDistance) in dataForWeek {
            result.append(AgeWeakAvg(weak: day, data: totalDistance))
        }
        
        return result
    }
    
    //MARK: - 선택한 연령대의 일주일치 평균 운동량
    private func updateWeakAgeAvgData() {
        
        guard let selectedDate = selectedDate else { return }
        
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)),
              let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) else {
            return
        }
        
        let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: startDate)!
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)!
        
        //        print("Start Date for the Week: \(startOfDay)")
        //        print("End Date for the Week: \(endOfDay)")
        let dataForThisWeek = getAgeDataForWeek(startDate: startOfDay, endDate: endOfDay)
        //        print("Data for This Week: \(dataForThisWeek)")
        
        for (dayIndex, day) in Calendar.current.weekdaySymbols.enumerated() {
            let dataForDay = dataForThisWeek.filter { $0.weak == day }
            if let averageData = dataForDay.first {
                weakAgeAvgData[dayIndex].data = averageData.data
            } else {
                weakAgeAvgData[dayIndex].data = 0
            }
        }
        
        //        print("연령대 데이터 업데이트: \(weakAgeAvgData)")
        
    }
    
    private func getAgeDataForWeek(startDate: Date, endDate: Date) -> [AgeWeakAvg] {
        //        print("시작 날짜 \(startDate), 끝 날짜 \(endDate)")
        //        print("뷰모델에서 가져온 데이터들1 : \(viewModel.allUserRunningLog)")
        let runningLogForWeek = viewModel.allUserRunningLog.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
        //        print("뷰모델에서 필터링해서 가져온 데이터들 : \(runningLogForWeek)")
        var dataForWeek: [String: (totalDistance: Double, count: Int)] = [:]
        let calendar = Calendar.current
        let weekDays = calendar.weekdaySymbols
        
        for day in weekDays {
            guard let dayIndex = calendar.weekdaySymbols.firstIndex(of: day) else {
                continue
            }
            let dataForDay = runningLogForWeek.filter {
                calendar.component(.weekday, from: $0.timestamp) == (dayIndex + calendar.firstWeekday - 1) % 7 + 1
            }
            
            let totalDistance = dataForDay.reduce(0.0) { $0 + $1.distance }
            let count = dataForDay.count
            dataForWeek[day] = (totalDistance, count)
        }
        
        var result: [AgeWeakAvg] = []
        for (day, data) in dataForWeek {
            var averageDistance = data.totalDistance / Double(data.count)
            if averageDistance.isNaN {
                averageDistance = 0
            }
            result.append(AgeWeakAvg(weak: day, data: averageDistance))
        }
        
        return result
    }
    
    //MARK: - 주별 백분율
    private func calculatePercentageIncreaseWeak() -> Double {
        // 0이 아닌 데이터들의 합과 개수를 계산하여 평균을 구합니다.
        let nonZeroDataCountMyAvg = weakMyAvgData.reduce(0) { $1.data != 0 ? $0 + 1 : $0 }
        let nonZeroDataCountAgeAvg = weakAgeAvgData.reduce(0) { $1.data != 0 ? $0 + 1 : $0 }
        
        // 0이 아닌 데이터가 없는 경우 nil을 반환합니다.
        guard nonZeroDataCountMyAvg > 0 && nonZeroDataCountAgeAvg > 0 else { return 0 }
        
        let sumMyAvg = weakMyAvgData.reduce(0.0) { $1.data != 0 ? $0 + $1.data : $0 }
        let sumAgeAvg = weakAgeAvgData.reduce(0.0) { $1.data != 0 ? $0 + $1.data : $0 }
        
        // 평균을 계산합니다.
        let avgMyAvg = sumMyAvg / Double(nonZeroDataCountMyAvg)
        let avgAgeAvg = sumAgeAvg / Double(nonZeroDataCountAgeAvg)
        
        // 백분율 증가율을 계산합니다.
        return ((avgMyAvg - avgAgeAvg) / avgAgeAvg) * 100
    }
    
    //MARK: - 저번주 데이터
    private func updateLastWeakMyAvgData() {
        guard let selectedDate = selectedDate else { return }
        
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)),
              let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) else {
            return
        }
        
        // Set start date time to 00:00:00 and end date time to 23:59:59
        let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: startDate)!
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)!
        
        // Get data for last week
        let dataForLastWeek = getDataForLastWeek(startDate: startOfDay, endDate: endOfDay)
        
        for (dayIndex, day) in Calendar.current.weekdaySymbols.enumerated() {
            let dataForDay = dataForLastWeek.filter { $0.weak == day }
            if let averageData = dataForDay.first {
                LastweakMyAvgData[dayIndex].data = averageData.data
            } else {
                LastweakMyAvgData[dayIndex].data = 0
            }
        }
    }
    
    private func getDataForLastWeek(startDate: Date, endDate: Date) -> [AgeWeakAvg] {
        let runningLogForLastWeek = viewModel.runningLog.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
        var dataForLastWeek: [String: Double] = [:]
        let calendar = Calendar.current
        let weekDays = calendar.weekdaySymbols
        
        for day in weekDays {
            guard let dayIndex = calendar.weekdaySymbols.firstIndex(of: day) else {
                continue
            }
            let dataForDay = runningLogForLastWeek.filter {
                calendar.component(.weekday, from: $0.timestamp) == (dayIndex + calendar.firstWeekday - 1) % 7 + 1
            }
            
            let totalDistance = dataForDay.reduce(0.0) { $0 + $1.distance }
            dataForLastWeek[day] = totalDistance
        }
        
        var result: [AgeWeakAvg] = []
        for (day, totalDistance) in dataForLastWeek {
            result.append(AgeWeakAvg(weak: day, data: totalDistance))
        }
        
        return result
    }
    
    private func countNonZeroValues(_ data: [AgeWeakAvg]) -> Int {
        return data.filter { $0.data != 0 }.count
    }
    
}

struct BarView: View {
    var value : CGFloat
    var isSelected : Bool
    @Binding var selectedDate: Date?
    
    var body: some View {
        
        VStack {
            ZStack(alignment: .bottom){
                Capsule()
                    .frame(maxWidth: 12, minHeight: 0, maxHeight: 100)
                    .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0))
                Capsule()
                    .frame(maxWidth: 12, minHeight: 0, maxHeight: (100 * (value / 20)) / 1000)
                    .foregroundColor(isSelected ? .main : .gray1)
                
            }
        }
        .id(selectedDate)
    }
}

struct AgeMonthAvg: Identifiable {
    var id = UUID()
    var month: String
    var data: Double
}

struct AgeWeakAvg: Identifiable {
    var id = UUID()
    var weak: String
    var data: Double
}

//#Preview {
////    BarGraphView()
//    WeakGraphView()
//}
