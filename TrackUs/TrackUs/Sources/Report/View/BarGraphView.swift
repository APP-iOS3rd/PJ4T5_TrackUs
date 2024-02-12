//
//  BarGraphView.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI
import Charts

struct BarGraphView: View {
    @State var selectedBarIndex: Int?
    @State var avg = 20
    
    let monthAvg = [13.5,10.2,7.8,9,0,3.0,15.0,11,12,10,11,13]
    let ageMonthAvg = [11.5,17.5,10.1,12.3,11.1,12.1,13.2,9.8,9.9,10.1,11.1,12.5]
    
    var ageAvgData = [
        AgeMonthAvg(month: "Jan", data: 11.5),
        AgeMonthAvg(month: "Feb", data: 17.5),
        AgeMonthAvg(month: "Mar", data: 10.1),
        AgeMonthAvg(month: "Apr", data: 12.3),
        AgeMonthAvg(month: "May", data: 11.1),
        AgeMonthAvg(month: "Jun", data: 12.1),
        AgeMonthAvg(month: "Jul", data: 13.2),
        AgeMonthAvg(month: "Aug", data: 9.8),
        AgeMonthAvg(month: "Sep", data: 9.9),
        AgeMonthAvg(month: "Oct", data: 10.1),
        AgeMonthAvg(month: "Nov", data: 11.1),
        AgeMonthAvg(month: "Dec", data: 12.5)
    ]
    
    var body: some View {
        VStack {
            
            Spacer()
            ZStack(alignment: .bottom) {
                Chart {
                    ForEach(ageAvgData) { item in
                        LineMark(x: .value("Month", item.month), y: .value("hours", item.data))
                    }
                }
//                .padding(.horizontal, 10)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .offset(y: 30)
                
                HStack(alignment: .bottom) {
                    ForEach(monthAvg.indices, id: \.self) { index in
                        let value = monthAvg[index]
                        ZStack {
                            VStack {
                                BarView(value: CGFloat(value), isSelected: selectedBarIndex == index).padding(.horizontal, 3)
                                Text(monthString(index - 1))
                                    .customFontStyle(.gray4_R9) // 696969 Regular 11 , 선택 되면 Bold
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
                                Text("\(value, specifier: "%.1f")km")
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
                Text("회원님의 5월 운동량은 20대 평균보다") +
                Text(" 1.7% ").bold().foregroundColor(.main) +
                Text("높으며 전달 대비 운동횟수가 ") +
                Text(" 3회 증가 ").bold().foregroundColor(.main) +
                Text("했습니다.")
            }
            .foregroundColor(.gray2)
            .font(.custom("Regular", size: 14))
            .padding(.top, 16)
        }
        .frame(height: 250)
    }
    
    func monthString(_ index: Int) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            let date = Calendar.current.date(byAdding: .month, value: index, to: Date())!
            return formatter.string(from: date)
        }
}

struct WeakGraphView: View {
    @State var selectedBarIndex: Int?
    @State var avg = 20
    
    let monthAvg = [13.5,10.2,7.8,9,0,3.0,15]
    let ageMonthAvg = [11.5,17.5,10.1,12.3,11.1,12.1,13.2]
    
    var ageAvgData = [
        AgeWeakAvg(weak: "Sun", data: 13.2),
        AgeWeakAvg(weak: "Mon", data: 11.5),
        AgeWeakAvg(weak: "Tue", data: 17.5),
        AgeWeakAvg(weak: "Wed", data: 10.1),
        AgeWeakAvg(weak: "Thu", data: 12.3),
        AgeWeakAvg(weak: "Fri", data: 11.1),
        AgeWeakAvg(weak: "Sat", data: 12.1)
    ]
    
    var body: some View {
        VStack {
            
            Spacer()
            ZStack(alignment: .bottom) {
                Chart {
                    ForEach(ageAvgData) { item in
                        LineMark(x: .value("Weak", item.weak), y: .value("Data", item.data))
                    }
                }
                .padding(.horizontal, 20)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .offset(y: 30)
                
                HStack(alignment: .bottom) {
                    ForEach(monthAvg.indices, id: \.self) { index in
                        let value = monthAvg[index]
                        ZStack {
                            VStack {
                                BarView(value: CGFloat(value), isSelected: selectedBarIndex == index).padding(.horizontal, 10)
                                Text(weakString(index - 1))
                                    .customFontStyle(.gray4_R9) // 696969 Regular 11 , 선택 되면 Bold
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
                                Text("\(value, specifier: "%.1f")km")
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
                Text("회원님의 이번주 운동량은 20대 평균보다") +
                Text(" 1.7% ").bold().foregroundColor(.main) +
                Text("높으며 전주 대비 운동횟수가") +
                Text(" 3회 증가 ").bold().foregroundColor(.main) +
                Text("했습니다.")
            }
            .foregroundColor(.gray2)
            .font(.custom("Regular", size: 14))
            .padding(.top, 16)
        }
        .frame(height: 250)
    }
    
    func weakString(_ index: Int) -> String {
        let weekDay = (index) % 7
        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"
        let date = Calendar.current.date(byAdding: .day, value: weekDay, to: Date())!
        return formatter.string(from: date)
    }
}

struct BarView: View {
    var value : CGFloat
    var isSelected : Bool
    
    var body: some View {
        
        VStack {
            ZStack(alignment: .bottom){
                Capsule()
                    .frame(maxWidth: 12, minHeight: 0, maxHeight: 100)
                    .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0))
                Capsule()
                    .frame(maxWidth: 12, minHeight: 0, maxHeight: 100 * (value / 20))
//                    .foregroundColor(.gray1)
                    .foregroundColor(isSelected ? .main : .gray1)
                
            }
        }
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

#Preview {
//    BarGraphView()
    WeakGraphView()
}
