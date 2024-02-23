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
    @ObservedObject var viewModel = ReportViewModel.shared
    var vGridItems = [GridItem()]
    @State var filterSelect : RecordFilter = .all
    @State private var calendarButton = false
    @State private var selectedFilter: RecordFilter?
    @State private var gridDelete = false
    @Binding var selectedDate: Date?
    @State var selectedRunningLog: Runninglog?
    @State var isDelete = false
    @State private var isMenuOpen = false
    
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
//                        152.asString(unit: .pace)
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
                        .onTapGesture {
                            isMenuOpen = true
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            calendarButton.toggle()
                        } label: {
                            Image("Calendar")
                        }
                    }
                    LazyVGrid(columns: vGridItems, spacing: 0) {
//                        ForEach(viewModel.runningLog, id: \.documentID) { item in
                        ForEach(filteredRunningLog, id: \.documentID) { item in
                            VStack {
                                ZStack {
                                    Button {
                                        selectedRunningLog = item
                                        router.push(.recordDetail(selectedRunningLog!))
                                    } label: {
                                        RecordCell(isDelete: $isDelete, gridDelete: $gridDelete, runningLog: item, isSelected: isRecordAvailableOnDate(runningLog: item, selectedDate: selectedDate))
                                    }
                                        HStack(alignment: .top) {
                                            Spacer()
                                            
                                            Menu {
                                                Button(role: .destructive ,action: {
                                                    self.isDelete = true
                                                    self.selectedRunningLog = item
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
                                                    .frame(width: 40, height: 40)
                                            }
                                            .foregroundColor(.gray1)
                                            .offset(y: -25)
                                            .onTapGesture {
                                                isMenuOpen = true
                                            }
                                        }
//                                    }
                                }
                                
                                Divider()
                                    .padding(.top, 24)
                                    .edgesIgnoringSafeArea(.all)
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
                
                if isMenuOpen {
                    Color.black.opacity(0.001)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isMenuOpen = false
                        }
                }
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
                .autohideIn(1)
        }
        
        .sheet(isPresented: $calendarButton,onDismiss: {
            
        }, content: {
            CustomDateFilter(selectedDate: $selectedDate, isPickerPresented: $calendarButton)
                .presentationDetents([.height(450)])
                .presentationDragIndicator(.hidden)
        })
        .alert("알림", isPresented: $isDelete) {
            Button("삭제", role: .destructive) {
                gridDelete = true
                print("삭제버튼")
                if let selectedRunningLog = selectedRunningLog {
                    
                    deleteRunningLog(selectedRunningLog: selectedRunningLog)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // 팝업이 없어지면 화면 새로고침
                        viewModel.fetchUserLog(selectedDate: selectedDate!)
                    }
                }
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("러닝 기록을 삭제하시겠습니까? \n 삭제한 러닝기록은 복구할 수 없습니다.")
        }
//        .refreshable {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                viewModel.fetchUserLog()
//            }
//        }
    }
    
    func isRecordAvailableOnDate(runningLog: Runninglog, selectedDate: Date?) -> Bool {
        guard let selectedDate = selectedDate else { return false }
        let calendar = Calendar.current
        let recordDate = calendar.startOfDay(for: runningLog.timestamp)
        let selectedDateWithoutTime = calendar.startOfDay(for: selectedDate)
        return recordDate == selectedDateWithoutTime
    }
    
    func deleteRunningLog(selectedRunningLog: Runninglog) {
        print("삭제 함수 시작")
        if let documentID = selectedRunningLog.documentID {
            print(documentID)
            viewModel.deleteRunningLog(documentID)
        }
    }
    
    var filteredRunningLog: [Runninglog] {
        switch selectedFilter {
        case .personal:
            return viewModel.runningLog.filter { $0.isGroup == false }
        case .mate:
            return viewModel.runningLog.filter { $0.isGroup == true }
        default:
            return viewModel.runningLog
        }
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
    @ObservedObject var viewModel = ReportViewModel.shared
    @Binding var isDelete: Bool
    @Binding var gridDelete : Bool
    let runningLog : Runninglog
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 10) {
                ImageView(urlString: runningLog.routeImageUrl)
                    .frame(width: 100, height: 100)
                    .cornerRadius(12)
                
                VStack(alignment: .leading) {
                    HStack {
                        
                        if runningLog.isGroup ?? false {
                            Text("러닝메이트")
                                .foregroundColor(.white)
                                .font(.system(size: 11))
                                .fontWeight(.semibold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(Color.orange2)
                                .cornerRadius(25)
                        } else {
                            Text("개인")
                                .foregroundColor(.white)
                                .font(.system(size: 11))
                                .fontWeight(.semibold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(Color.main)
                                .cornerRadius(25)
                        }
                        
                        Spacer()
                    }
                    
                    //                    Text("광명시 러닝 메이트 구합니다")
                    Text(runningLog.title ?? "러닝")
                        .lineLimit(1)
                        .customFontStyle(.gray1_B16)
                    
                    HStack(spacing: 10) {
                        HStack {
                            Image(.pin)
                            //                            Text("서울숲카페거리")
                            Text(runningLog.address ?? "대한민국 서울시")
//                                .customFontStyle(.gray1_R12)
                                .customFontStyle(.gray1_R9)
                                .lineLimit(1)
                        }
                        
                        //                        Spacer()
                        
                        HStack {
                            Image(.timerLine)
                            //                            Text("10:02 AM")
                            Text(formatTime(runningLog.timestamp))
//                                .customFontStyle(.gray1_R12)
                                .customFontStyle(.gray1_R9)
                        }
                        
                        //                        Spacer()
                        
                        HStack {
                            Image(.arrowBoth)
                            //                            Text("1.72km")
//                            Text("\(runningLog.distance / 1000.0, specifier:"%.2f")km")
                            Text("\((runningLog.distance / 1000.0).asString(unit: .kilometer))") // 수정된부분^^
//                                .customFontStyle(.gray1_R12)
                                .customFontStyle(.gray1_R9)
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
                        Text(formatDate(runningLog.timestamp))
                            .customFontStyle(.gray1_SB12)
                    }
                }
            }
            
        }
        .padding(.top, 24)
    }
    
    func formatTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: date)
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: date)
    }
}

//MARK: - 커스텀 캘린더

struct CustomDateFilter: View {
    @ObservedObject var viewModel = ReportViewModel.shared
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
                        }
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
        .background(value.day != -1 && isSelected ? .main : .white)
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
        for record in viewModel.runningLog { // 임시
            if calendar.isDate(record.timestamp, inSameDayAs: date) {
                return true
            }
        }
        return false
    }
    
}

//#Preview {
//    MyRecordView()
////    RecordCell()
//}
