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
    @Binding var selectedAge: AvgAge
    @ObservedObject var viewModel = ReportViewModel.shared
    @Binding var selectedDate: Date?
    @State private var exerciseCountByDate: [Date: Int] = [:]
    
    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .bottom) {
                Chart {
                    ForEach(viewModel.monthAgeAvgData) { item in
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
                    ForEach(viewModel.monthMyAvgData.indices, id: \.self) { index in
                        let avgData = viewModel.monthMyAvgData[index]
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
//                                Text((avgData.data / 1000).asString(unit: .kilometer))
                                Text((avgData.data).asString(unit: .kilometer))
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
                    let selectedMonth = viewModel.monthMyAvgData[selectedBarIndex]
                    let previousMonthIndex = selectedBarIndex > 0 ? selectedBarIndex - 1 : viewModel.monthMyAvgData.count - 1
                    let previousMonth = viewModel.monthMyAvgData[previousMonthIndex]
                    
                    let currentMonthExerciseCount = getExerciseCount(for: selectedMonth.month)
                    let previousMonthExerciseCount = getExerciseCount(for: previousMonth.month)
                    
                    let monthString = "\(selectedBarIndex + 1)월"
                    Text("회원님의 \(monthString) 운동량은 \(selectedAge.rawValue) 평균보다") +
                        Text(" \(calculatePercentageIncreaseMonth(selectedMonth: selectedMonth), specifier: "%.1f")% ").bold().foregroundColor(.main) +
                        Text("\(calculatePercentageIncreaseMonth(selectedMonth: selectedMonth) > 0 ? "높으며" : "낮으며") 전달 대비 운동횟수가 ") +
                        Text("\(abs(currentMonthExerciseCount - previousMonthExerciseCount))회 \(currentMonthExerciseCount >= previousMonthExerciseCount ? "증가" : "감소") ").bold().foregroundColor(.main) +
                        Text("했습니다.")
                } else {
                    Text("그래프를 선택해주세요")
                        .padding(.top, 16)
                }
            }
            .foregroundColor(.gray2)
            .font(.custom("Regular", size: 14))
            .padding(.top, 16)
        }
        .frame(height: 250)
        .onAppear {
            if let selectedDate = selectedDate {
                updateExerciseCountForSelectedDate(selectedDate: selectedDate)
            }
        }
        .id(selectedDate)
    }
    
    // 월별 백분률
    private func calculatePercentageIncreaseMonth(selectedMonth: AgeMonthAvg) -> Double {

        let nonZeroDataCountMyAvg = viewModel.monthMyAvgData.reduce(0) { $1.data != 0 ? $0 + 1 : $0 }
        let nonZeroDataCountAgeAvg = viewModel.monthAgeAvgData.reduce(0) { $1.data != 0 ? $0 + 1 : $0 }
        
        guard nonZeroDataCountMyAvg > 0 && nonZeroDataCountAgeAvg > 0 else { return 0 }
        
        let sumMyAvg = viewModel.monthMyAvgData.reduce(0.0) { $1.data != 0 ? $0 + $1.data : $0 }
        let sumAgeAvg = viewModel.monthAgeAvgData.reduce(0.0) { $1.data != 0 ? $0 + $1.data : $0 }
        
        let avgMyAvg = sumMyAvg / Double(nonZeroDataCountMyAvg)
        let avgAgeAvg = sumAgeAvg / Double(nonZeroDataCountAgeAvg)
        
        return ((selectedMonth.data - avgAgeAvg) / avgAgeAvg) * 100
    }
    
    func getExerciseCount(for month: String) -> Int {
        guard let selectedDate = selectedDate else { return 0 }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let startDate = dateFormatter.date(from: "\(year)-\(month)")!
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
        
        let dataForMonth = viewModel.runningLog.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
        
        return dataForMonth.count
    }
    
    func updateExerciseCountForSelectedDate(selectedDate: Date) {
        let runningLog = viewModel.runningLog
        
        let filteredLogs = runningLog.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDate) }
        let exerciseCount = filteredLogs.count
        exerciseCountByDate[selectedDate] = exerciseCount
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
    
    var body: some View {
        
        if case .loading = viewModel.userLogLoadingState {
            Text("Loading")
        } else {
            
            VStack {
                Spacer()
                ZStack(alignment: .bottom) {
                    Chart {
                        ForEach(viewModel.weakAgeAvgData) { item in
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
                    .offset(y: -30)
                    
                    HStack(alignment: .bottom) {
                        ForEach(viewModel.weakMyAvgData.indices, id: \.self) { index in
                            let avgData = viewModel.weakMyAvgData[index]
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
                                    Text((avgData.data).asString(unit: .kilometer))
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
                
                let lastWeek = countNonZeroValues(viewModel.LastweakMyAvgData)
                let currentWeek = countNonZeroValues(viewModel.weakMyAvgData)
                
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
                    viewModel.updateWeakMyAvgData(selectedDate: selectedDate!)
                    viewModel.updateWeakAgeAvgData(selectedDate: selectedDate!)
                    viewModel.updateLastWeakMyAvgData(selectedDate: selectedDate!)
                }
            }
            .id(selectedDate)
        }
    }
    
//MARK: - 주별 백분율
    private func calculatePercentageIncreaseWeak() -> Double {
        // 0이 아닌 데이터들의 합과 개수를 계산하여 평균을 구합니다.
        let nonZeroDataCountMyAvg = viewModel.weakMyAvgData.reduce(0) { $1.data != 0 ? $0 + 1 : $0 }
        let nonZeroDataCountAgeAvg = viewModel.weakAgeAvgData.reduce(0) { $1.data != 0 ? $0 + 1 : $0 }
        
        // 0이 아닌 데이터가 없는 경우 nil을 반환합니다.
        guard nonZeroDataCountMyAvg > 0 && nonZeroDataCountAgeAvg > 0 else { return 0 }
        
        let sumMyAvg = viewModel.weakMyAvgData.reduce(0.0) { $1.data != 0 ? $0 + $1.data : $0 }
        let sumAgeAvg = viewModel.weakAgeAvgData.reduce(0.0) { $1.data != 0 ? $0 + $1.data : $0 }
        
        // 평균을 계산합니다.
        let avgMyAvg = sumMyAvg / Double(nonZeroDataCountMyAvg)
        let avgAgeAvg = sumAgeAvg / Double(nonZeroDataCountAgeAvg)
        
        // 백분율 증가율을 계산합니다.
        return ((avgMyAvg - avgAgeAvg) / avgAgeAvg) * 100
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
//                    .frame(maxWidth: 12, minHeight: 0, maxHeight: (100 * (value / 20)) / 1000)
                    .frame(maxWidth: 12, minHeight: 0, maxHeight: (100 * (value / 5)) / 1000)
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
