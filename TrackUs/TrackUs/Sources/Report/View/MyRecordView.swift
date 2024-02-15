//
//  MyRunningRecordView.swift
//  TrackUs
//
//  Created by 박선구 on 2/10/24.
//

import SwiftUI
import Firebase

enum RecordFilter: String, CaseIterable, Identifiable { // 나이대 피커
    case all = "전체"
    case personal = "개인"
    case mate = "러닝메이트"
    
    var id: Self { self }
}

struct MyRecordView: View {
    @EnvironmentObject var router: Router
    var vGridItems = [GridItem()]
    @State var filterSelect : RecordFilter = .all
    @State private var calendarButton = false
    @State private var selectedFilter: RecordFilter?
    @State private var gridDelete = false
    @State var selectedDate: Date? = Date()
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Button {
                        router.present(fullScreenCover: .payment)
                    } label: {
                        GraphicTextCard(title: "TrackUs Pro", subTitle: "상세한 러닝 리포트를 통해 효율적인 러닝을 즐겨보세요.", resource: .iconTrackUsPro2)
                            .modifier(BorderLineModifier())
                            .multilineTextAlignment(.leading)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("러닝 기록")
                            .customFontStyle(.gray1_B24)
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                        Text("러닝 기록과 상세 러닝 정보를 확인해보세요.")
                            .customFontStyle(.gray2_R15)
                            .padding(.bottom, 20)
                    }
                    
                    HStack {
                        Menu {
                            ForEach(RecordFilter.allCases) { filter in
                                Button {
                                    selectedFilter = filter
                                } label: {
                                    Text(filter.rawValue)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedFilter?.rawValue ?? "전체")
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
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            calendarButton.toggle()
                        } label: {
                            Image("Calendar")
                        }
                    }
                    
                    // RecordCell
                    LazyVGrid(columns: vGridItems, spacing: 0) {
//                        ForEach(0...6, id: \.self) { item in
                        ForEach(RecordLog.mockData) { item in
//                            RecordCell(gridDelete: $gridDelete, record: item)
                            RecordCell(gridDelete: $gridDelete, record: item, isSelected: isRecordAvailableOnDate(record: item, selectedDate: selectedDate))
                            Divider()
                                .padding(.top, 24)
                                .edgesIgnoringSafeArea(.all)
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
            }
        }
        .popup(isPresented: $gridDelete) {
            HStack {
                Image(.trashSlash)
                
                Spacer()
                
                Text("러닝 기록이 삭제되었습니다.")
                    .customFontStyle(.gray1_SB16)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                    .foregroundColor(.gray3)
            )
            .clipShape(Capsule())
            .padding(45)
            .shadow(radius: 5)
            .offset(y: 30)
            
        } customize: {
            $0
                .type(.floater())
                .position(.bottom)
                .animation(.smooth)
                .autohideIn(2)
        }
        
        .sheet(isPresented: $calendarButton,onDismiss: {
            
        }, content: {
            CustomDateFilter(selectedDate: $selectedDate, isPickerPresented: $calendarButton)
                .presentationDetents([.height(450)])
                .presentationDragIndicator(.hidden)
        })
    }
    
    func isRecordAvailableOnDate(record: RecordLog, selectedDate: Date?) -> Bool {
        guard let selectedDate = selectedDate else { return false }
        let calendar = Calendar.current
        let recordDate = calendar.startOfDay(for: record.timestamp.dateValue())
        let selectedDateWithoutTime = calendar.startOfDay(for: selectedDate)
        return recordDate == selectedDateWithoutTime
    }
}

extension MyRecordView {
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

//MARK: - RecordCell
struct RecordCell: View {
    @State private var isDelete = false
    @Binding var gridDelete : Bool
    let record : RecordLog
    let isSelected: Bool // 추가한 내용
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 10) {
                Image(.mapPath)
                    .resizable()
                //                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(12)
                //                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    HStack {
//                        Text("러닝메이트")
//                            .foregroundColor(.white)
//                            .font(.system(size: 11))
//                            .fontWeight(.semibold)
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 3)
//                            .background(Color.orange2)
//                            .cornerRadius(25)
                        Text("개인")
                            .foregroundColor(.white)
                            .font(.system(size: 11))
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(Color.main)
                            .cornerRadius(25)
                        
                        Spacer()
                        
                        Menu {
                            Button(role: .destructive ,action: {
                                self.isDelete = true
                            }) {
                                Text("러닝기록 삭제")
                            }
                            
                            Button {
                                
                            } label: {
                                Text("취소")
                            }
                            .foregroundColor(.gray1)
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .frame(width: 20, height: 20)
                        }
                        .foregroundColor(.gray1)
                    }
                    
//                    Text("광명시 러닝 메이트 구합니다")
                    Text(record.title)
                        .lineLimit(1)
                        .customFontStyle(.gray1_B16)
                    
                    HStack(spacing: 10) {
                        HStack {
                            Image(.pin)
//                            Text("서울숲카페거리")
                            Text(record.location)
                                .customFontStyle(.gray1_R12)
                                .lineLimit(1)
                        }
                        
//                        Spacer()
                        
                        HStack {
                            Image(.timerLine)
//                            Text("10:02 AM")
                            Text(formatTime(record.timestamp))
                                .customFontStyle(.gray1_R12)
                        }
                        
//                        Spacer()
                        
                        HStack {
                            Image(.arrowBoth)
//                            Text("1.72km")
                            Text("\(record.distance, specifier:"%.1f")km")
                                .customFontStyle(.gray1_R12)
                        }
                    }
                    
                    HStack {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .resizable()
                                .frame(width: 15, height: 12)
                                .foregroundColor(.gray1)
                            
                            Text("1")
//                            Text(" ")
                                .customFontStyle(.gray1_M16)
                        }
                        
                        Spacer()
                        
//                        Text("2024년 2월 12일")
                        Text(formatDate(record.timestamp))
                            .customFontStyle(.gray1_SB12)
                    }
                }
            }
            
        }
        .padding(.top, 24)
        .alert("알림", isPresented: $isDelete) {
            Button("삭제", role: .destructive) {
                gridDelete = true
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("러닝 기록을 삭제하시겠습니까? \n 삭제한 러닝기록은 복구할 수 없습니다.")
        }
    }
    
    func formatTime(_ timestamp: Timestamp) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm a"
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    return dateFormatter.string(from: timestamp.dateValue())
    }
    
    func formatDate(_ timestamp: Timestamp) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    return dateFormatter.string(from: timestamp.dateValue())
    }
}

struct RecordLog : Identifiable, Hashable {
    let id: String
    let title: String
    let location: String
    let distance: Double
    let timestamp: Timestamp
//    let date: Timestamp
    let withMate: Bool
//    let person: Int
//    var user: User? // 백엔드에서 작업을 설정하는 방법 떄문에 var 이며 옵셔널이다?
//    var person: Int?
}

extension RecordLog {
    
    
//    static let mockData: [RunningRecord] = [
//        .init(id: NSUUID().uuidString, title: "중랑의 아들과 함께하는 중랑천 여행", location: "서울시 중랑천", distance: 4.19, timestamp: Timestamp(), withMate: false),
//        .init(id: NSUUID().uuidString, title: "상봉동 뛰댕기기", location: "중랑구 상봉동", distance: 1.25, timestamp: Timestamp(), withMate: false),
//        .init(id: NSUUID().uuidString, title: "용산에서 메이트 모집을 합니다.", location: "서울시 용산구", distance: 6.7, timestamp: Timestamp(), withMate: false),
//        .init(id: NSUUID().uuidString, title: "바나나 우유를 좋아합니다", location: "경기도 동두천시 동두천길 동두천", distance: 2.3, timestamp: Timestamp(), withMate: false)
//    ]
    
    static let mockData: [RecordLog] = {
            let calendar = Calendar.current
            
            let feb1Components = DateComponents(year: 2024, month: 2, day: 1)
            let feb1Date = calendar.date(from: feb1Components)!
            let feb1Timestamp = Timestamp(date: feb1Date)
            
            let feb5Components = DateComponents(year: 2024, month: 2, day: 5)
            let feb5Date = calendar.date(from: feb5Components)!
            let feb5Timestamp = Timestamp(date: feb5Date)
            
            let jan12Components = DateComponents(year: 2024, month: 1, day: 12)
            let jan12Date = calendar.date(from: jan12Components)!
            let jan12Timestamp = Timestamp(date: jan12Date)
            
            let mar9Components = DateComponents(year: 2024, month: 3, day: 9)
            let mar9Date = calendar.date(from: mar9Components)!
            let mar9Timestamp = Timestamp(date: mar9Date)
            
            return [
                .init(id: NSUUID().uuidString, title: "중랑의 아들과 함께하는 중랑천 여행", location: "서울시 중랑천", distance: 4.19, timestamp: feb1Timestamp, withMate: false),
                .init(id: NSUUID().uuidString, title: "상봉동 뛰댕기기", location: "중랑구 상봉동", distance: 1.25, timestamp: feb5Timestamp, withMate: false),
                .init(id: NSUUID().uuidString, title: "용산에서 메이트 모집을 합니다.", location: "서울시 용산구", distance: 6.7, timestamp: jan12Timestamp, withMate: false),
                .init(id: NSUUID().uuidString, title: "바나나 우유를 좋아합니다", location: "경기도 동두천시 동두천길 동두천", distance: 2.3, timestamp: mar9Timestamp, withMate: false)
            ]
        }()
}

//MARK: - 커스텀 캘린더

struct CustomDateFilter: View {
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
        VStack {
            ZStack(alignment: .center) {
                if value.day != -1 {
                    Text("\(value.day)")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(isSelected ? .white : isSameDay(date1: value.date, date2: currentDate) ? .gray1 : (isSameMonth(date1: value.date, date2: currentDate) && value.date > Date() ? .gray1 : .gray1))
                        .frame(width: 30)
                        .frame(height: 20)
                    
                    if isMockDataAvailableOnDate(date: value.date) {
                        HStack(spacing: 4) {
                            Circle()
                                .foregroundColor(isSelected ? .white : .main)
                                .frame(width: 5, height: 5)
                                .offset(y: 12)
                            Circle()
                                .foregroundColor(.orange2)
                                .frame(width: 5, height: 5)
                                .offset(y: 12)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
        .background(value.day != -1 && isSelected ? .main : .white)
//        .background(isSelected ? .main : .white)
//        .background(isSelected && value.day == -1 ? .white : .white)
        .cornerRadius(30)
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
    
//    func extractDate() ->[DateValue]{
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
    
    func isMockDataAvailableOnDate(date: Date) -> Bool {
        let calendar = Calendar.current
        for record in RecordLog.mockData { // 임시
            if calendar.isDate(record.timestamp.dateValue(), inSameDayAs: date) {
                return true
            }
        }
        return false
    }
    
}

#Preview {
    MyRecordView()
//    RecordCell()
}
