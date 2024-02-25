//
//  CustomDatePicker.swift
//  TrackUs
//
//  Created by 박선구 on 2/13/24.
//

import SwiftUI

//MARK: - 달력

struct CustomDatePicker: View {
    //    @Binding var currentDate: Date
    @State var currentDate: Date = Date()
    @State var currentMonth: Int = 0
    @Binding var selectedDate: Date?
    @Binding var isPickerPresented: Bool
    
    var body: some View {
        VStack(spacing: 35){
            
            
            let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
            ZStack (alignment: .trailing){
                HStack(spacing: 20){
                    
                    Spacer()
                    
                    Button {
                        withAnimation{
                            currentMonth -= 1
                        }
                    } label: {
                        Image(systemName: "arrowtriangle.left.fill")
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 10){
                        
                        Text(extraDate()[1])
                            .customFontStyle(.white_B16)
                    }
                    
                    Button {
                        withAnimation{
                            currentMonth += 1
                        }
                    } label: {
                        Image(systemName: "arrowtriangle.right.fill")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    
                }
                .padding(.vertical)
                .background(Color.main)
                
                Button {
                    isPickerPresented.toggle()
                } label: {
                    Text("확인")
                        .customFontStyle(.white_B16)
                }
                .padding()
                
            }
            
            HStack(spacing: 0){
                ForEach(days, id: \.self){ day in
                    
                    Text(day)
                        .customFontStyle(.gray1_B16)
                        .frame(maxWidth: .infinity, maxHeight: 1)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(extractDate()) { value in
                    CardView(value: value, isSelected: isSameDay(date1: value.date, date2: selectedDate ?? Date()))
                        .onTapGesture {
                            selectedDate = value.date
                        }
                }
            }
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .cornerRadius(10)
        .onChange(of: currentMonth) { newValue in
            
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue, isSelected: Bool) -> some View {
        ZStack {
            VStack {
                if value.day != -1 {
                    Text("\(value.day)")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(isSelected ? .white : isSameDay(date1: value.date, date2: currentDate) ? .black : (isSameMonth(date1: value.date, date2: currentDate) && value.date > Date() ? .gray1 : .gray1))
                        .frame(width: 30)
                        .frame(height: 20)
                }
            }
            .padding(.vertical, 5)
            .background(isSelected ? .main : .white)
            .cornerRadius(30)
        }
    }
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: currentDate)
    }
    
    func isSameDay(date1: Date, date2: Date)-> Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extraDate()-> [String]{
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy MMMM "
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth()->Date{
        
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() ->[DateValue]{
        
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap{ date -> DateValue in
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
    func isSameMonth(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month], from: date1)
        let components2 = calendar.dateComponents([.year, .month], from: date2)
        return components1 == components2
    }
    
}

extension Date{
    
    func getAllDates() -> [Date]{
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day: Int
    var date: Date
}

//MARK: - 월별 선택 피커

struct MonthPicker: View {
    let months: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    @State var currentDate: Date = Date()
    @Binding var isPickerPresented: Bool
    @Binding var selectedDate: Date?
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 10), count: 4)
    
    var body: some View {
        VStack {
            ZStack (alignment: .trailing){
                HStack(spacing: 20){
                    
                    Spacer()
                    
                    Button {
                        adjustYear(by: -1)
                    } label: {
                        Image(systemName: "arrowtriangle.left.fill")
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 10){
                        
                        Text(extraDate()[0])
                            .customFontStyle(.white_B16)
                    }
                    
                    Button {
                        adjustYear(by: 1)
                    } label: {
                        Image(systemName: "arrowtriangle.right.fill")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    
                }
                .padding(.vertical)
                .background(Color.main)
                
                Button {
                    isPickerPresented.toggle()
                } label: {
                    Text("확인")
                        .customFontStyle(.white_B16)
                }
                .padding()
                
            }
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(months.indices, id: \.self) { index in
                    Button(action: {
                        // 선택한 월에 해당하는 첫 번째 날짜 가져오기
                        let selectedMonth = index + 1 // 월은 1부터 시작
                        let selectedYear = Calendar.current.component(.year, from: currentDate)
                        var components = DateComponents()
                        components.year = selectedYear
                        components.month = selectedMonth
                        components.day = 1 // 선택한 월의 첫 번째 날짜
                        selectedDate = Calendar.current.date(from: components)
                    }) {
                        ZStack {
                            if selectedDate != nil && index == Calendar.current.component(.month, from: selectedDate!) - 1 {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.main)
                            }
                            
                            VStack {
                                Text(months[index])
                                    .customFontStyle(selectedDate != nil && index == Calendar.current.component(.month, from: selectedDate!) - 1 ? .white_B16 : .gray1_SB16)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .cornerRadius(8)
                        }
                        .background(.white)
                    }
                }
            }
            .padding()
            
            Spacer()
        }
    }
    
    func adjustYear(by value: Int) {
        currentDate = Calendar.current.date(byAdding: .year, value: value, to: currentDate) ?? Date()
    }
    
    func extraDate()-> [String]{
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy MMMM "
        
        return formatter.string(from: currentDate).components(separatedBy: " ")
    }
}

//#Preview {
////    CustomDatePicker(, isPickerPresented: <#Binding<Bool>#>)
//    MonthPicker(selectedMonthIndex: 0)
//}
