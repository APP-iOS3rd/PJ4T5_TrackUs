//
//  ReportViewModel.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

struct Runninglog : Hashable {
    var documentID: String? // 추가 문서ID
    var calorie: Double
    var distance: Double
    var elapsedTime: Double
    var pace: Double
    var timestamp: Date
    var address: String?
    var coordinates: [GeoPoint]?
    var routeImageUrl: String?
    var title: String?
    var targetDistance: Double?
    var isGroup: Bool?
}

class ReportViewModel : ObservableObject {
    enum LoadingState {
        case loading
        case loaded
        case error(String)
    }
    
    static let shared = ReportViewModel()
    
    @Published var runningLog = [Runninglog]()
//    @Published var runningLog = [UserRunningLog]()
    @Published var allUserRunningLog = [Runninglog]()
    @Published var userAge: Int = AvgAge.twenties.intValue
    
    @Published var userLogLoadingState = LoadingState.loading // 유저 로그 로딩상태
    
    @Published var monthAgeAvgData : [AgeMonthAvg] = [
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
    
    @Published var monthMyAvgData : [AgeMonthAvg] = [
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
    
    @Published var weakAgeAvgData : [AgeWeakAvg] = [
        AgeWeakAvg(weak: "Sun", data: 0),
        AgeWeakAvg(weak: "Mon", data: 0),
        AgeWeakAvg(weak: "Tue", data: 0),
        AgeWeakAvg(weak: "Wed", data: 0),
        AgeWeakAvg(weak: "Thu", data: 0),
        AgeWeakAvg(weak: "Fri", data: 0),
        AgeWeakAvg(weak: "Sat", data: 0)
    ]
    
    @Published var LastweakMyAvgData : [AgeWeakAvg] = [
        AgeWeakAvg(weak: "Sun", data: 0),
        AgeWeakAvg(weak: "Mon", data: 0),
        AgeWeakAvg(weak: "Tue", data: 0),
        AgeWeakAvg(weak: "Wed", data: 0),
        AgeWeakAvg(weak: "Thu", data: 0),
        AgeWeakAvg(weak: "Fri", data: 0),
        AgeWeakAvg(weak: "Sat", data: 0)
    ]
    
    @Published var weakMyAvgData : [AgeWeakAvg] = [
        AgeWeakAvg(weak: "Sun", data: 0),
        AgeWeakAvg(weak: "Mon", data: 0),
        AgeWeakAvg(weak: "Tue", data: 0),
        AgeWeakAvg(weak: "Wed", data: 0),
        AgeWeakAvg(weak: "Thu", data: 0),
        AgeWeakAvg(weak: "Fri", data: 0),
        AgeWeakAvg(weak: "Sat", data: 0)
    ]
    
    let db = Firestore.firestore()
    
    
    //MARK: - 로그인한 유저의 러닝 정보 불러오기
    
    func fetchUserLog(selectedDate: Date) {
        // 데이터 로딩 시작
        userLogLoadingState = .loading
        runningLog = []
        
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            print("error uid is nil")
            return
        }
        
//        let db = Firestore.firestore()
        db.collection("users").document(uid).collection("runningRecords").getDocuments() { (snapshot, error) in
            if let error = error {
                print("error fetching runningRecords: \(error.localizedDescription)")
                return
            }
            
            //3번째
            for runningData in snapshot!.documents {
                let documentID = runningData.documentID // 추가 문서 ID
                if let calorie = runningData.data()["calorie"] as? Double,
                   let distance = runningData.data()["distance"] as? Double,
                   let elapsedTime = runningData.data()["elapsedTime"] as? Double,
                   let pace = runningData.data()["pace"] as? Double,
                   let timestamp = runningData.data()["timestamp"] as? Timestamp {
                    let dateValue = timestamp.dateValue()
                    
                    // 값이 없는 경우 nil 처리.
                    let title = runningData.data()["title"] as? String
                    let address = runningData.data()["address"] as? String
                    let routeImageUrl = runningData.data()["routeImageUrl"] as? String
                    let coordinates = runningData.data()["coordinates"] as? [GeoPoint]
                    let targetDistance = runningData.data()["targetDistance"] as? Double
                    let isGroup = runningData.data()["isGroup"] as? Bool
                    
//                    let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue, address: address, coordinates: coordinates, routeImageUrl: routeImageUrl, title: title)
                    let log = Runninglog(documentID: documentID, calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue, address: address, coordinates: coordinates, routeImageUrl: routeImageUrl, title: title, targetDistance: targetDistance, isGroup: isGroup)
                    
                    if !self.runningLog.contains(log) {
                        self.runningLog.append(log)
                    }
//                    self.runningLog.append(log)
                }
            }
            
            self.runningLog.sort { $0.timestamp > $1.timestamp }
            
            self.userLogLoadingState = .loaded // 데이터 로드 완료
            
            self.updateMonthMyAvgData(selectedDate: selectedDate)
            self.updateWeakMyAvgData(selectedDate: selectedDate)
            self.updateLastWeakMyAvgData(selectedDate: selectedDate)
        }
    }
    
    //MARK: - 선택한 연령대 유저들의 러닝 정보 불러오기
    
    func fetchUserAgeLog(selectedDate: Date) {
        // 데이터 로딩 시작
        userLogLoadingState = .loading
        
        allUserRunningLog = []
        
        let db = Firestore.firestore()
        db.collection("users").whereField("age", isEqualTo: userAge).getDocuments() { (snapshot, error) in
            if let error = error {
                print("error fetching SameAgeUser")
                return
            }
            
            for document in snapshot!.documents {
                let userID = document.documentID
                db.collection("users").document(userID).collection("runningRecords").getDocuments() { (snapshot, error) in
                    if let error = error {
                        print("Error fetching SameAgeUser Running Log")
                        return
                    }
                    
                    //3번째
                    for runningData in snapshot!.documents {
                        if let calorie = runningData.data()["calorie"] as? Double,
                           let distance = runningData.data()["distance"] as? Double,
                           let elapsedTime = runningData.data()["elapsedTime"] as? Double,
                           let pace = runningData.data()["pace"] as? Double,
                           let timestamp = runningData.data()["timestamp"] as? Timestamp {
                            let dateValue = timestamp.dateValue()
                            
                            // title과 address 필드의 값을 읽어옵니다. 값이 없는 경우 nil로 처리.
                            let title = runningData.data()["title"] as? String
                            let address = runningData.data()["address"] as? String
                            let routeImageUrl = runningData.data()["routeImageUrl"] as? String
                            let coordinates = runningData.data()["coordinates"] as? [GeoPoint]
                            let targetDistance = runningData.data()["targetDistance"] as? Double
                            let isGroup = runningData.data()["isGroup"] as? Bool
                            
                            let log = Runninglog(calorie: calorie, distance: distance, elapsedTime: elapsedTime, pace: pace, timestamp: dateValue, address: address, coordinates: coordinates, routeImageUrl: routeImageUrl, title: title, targetDistance: targetDistance, isGroup: isGroup)
                            
                            if !self.allUserRunningLog.contains(log) {
                                self.allUserRunningLog.append(log)
                            }
//                            self.allUserRunningLog.append(log)
                        }
                    }
                    
                    self.allUserRunningLog.sort { $0.timestamp > $1.timestamp }
                    
                    self.userLogLoadingState = .loaded
                    
                    self.updateWeakAgeAvgData(selectedDate: selectedDate)
                    self.updateMonthAgeAvgData(selectedDate: selectedDate)
                }
            }
        }
    }
    
    func deleteRunningLog(_ documentID: String) { // 러닝삭제
        
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else {
            return
        }
        
        let docRef = db.collection("users").document(uid).collection("runningRecords").document(documentID)
        docRef.delete() { error in
            if let error = error {
                print("삭제 실패:", error.localizedDescription)
            } else {
                print("삭제 성공")
            }
        }
    }
    
    //MARK: - BarGraphView에서 사용하는 함수들 월별
    
    func updateMonthMyAvgData(selectedDate: Date) { // 월별 데이터
//        guard let selectedDate = selectedDate else { return }
        
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
    
    func getDataForMonth(startDate: Date, endDate: Date) -> [AgeMonthAvg] {
//        let runningLogForMonth = viewModel.runningLog.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
        let runningLogForMonth = runningLog.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
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
    
    func updateMonthAgeAvgData(selectedDate: Date) {
//        guard let selectedDate = selectedDate else { return }
        
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
    
    func ageDataForMonth(startDate: Date, endDate: Date) -> [AgeMonthAvg] {
        let runningLogForMonth = allUserRunningLog.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
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
    
    func calculateChangeInDataCount(selectedDate: Date) -> Int {
//        guard let selectedDate = selectedDate else { return 0 }
        
        let calendar = Calendar.current
        let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: selectedDate)!
        
        let previousMonthDataCount = getDataCount(for: previousMonthDate)
        let currentMonthDataCount = getDataCount(for: selectedDate)
        
        return currentMonthDataCount - previousMonthDataCount
    }
    
    func getDataCount(for date: Date) -> Int {
        let calendar = Calendar.current
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart)!
        
        let dataForMonth = runningLog.filter { $0.timestamp >= monthStart && $0.timestamp <= monthEnd }
        
        return dataForMonth.count
    }
    
    //MARK: - BarGraphView에서 사용하는 함수들 주별
    
    func updateWeakMyAvgData(selectedDate: Date) {
//        guard let selectedDate = selectedDate else { return }
        
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
    
    
    func getDataForWeek(startDate: Date, endDate: Date) -> [AgeWeakAvg] {
        //        print("시작 날짜 \(startDate), 끝 날짜 \(endDate)")
//        print("여기서부터 시작!!!!!!!\(viewModel.runningLog) 여기까지가 끝!!!!!!")
        let runningLogForWeek = runningLog.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
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
    func updateWeakAgeAvgData(selectedDate: Date) {
        
//        guard let selectedDate = selectedDate else { return }
        
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
    
    func getAgeDataForWeek(startDate: Date, endDate: Date) -> [AgeWeakAvg] {
        //        print("시작 날짜 \(startDate), 끝 날짜 \(endDate)")
        //        print("뷰모델에서 가져온 데이터들1 : \(viewModel.allUserRunningLog)")
        let runningLogForWeek = allUserRunningLog.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
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
    func calculatePercentageIncreaseWeak() -> Double {
        let nonZeroDataCountMyAvg = weakMyAvgData.reduce(0) { $1.data != 0 ? $0 + 1 : $0 }
        let nonZeroDataCountAgeAvg = weakAgeAvgData.reduce(0) { $1.data != 0 ? $0 + 1 : $0 }
        
        guard nonZeroDataCountMyAvg > 0 && nonZeroDataCountAgeAvg > 0 else { return 0 }
        
        let sumMyAvg = weakMyAvgData.reduce(0.0) { $1.data != 0 ? $0 + $1.data : $0 }
        let sumAgeAvg = weakAgeAvgData.reduce(0.0) { $1.data != 0 ? $0 + $1.data : $0 }
        
        let avgMyAvg = sumMyAvg / Double(nonZeroDataCountMyAvg)
        let avgAgeAvg = sumAgeAvg / Double(nonZeroDataCountAgeAvg)
        
        return ((avgMyAvg - avgAgeAvg) / avgAgeAvg) * 100
    }
    
    //MARK: - 저번주 데이터
    
    func updateLastWeakMyAvgData(selectedDate: Date) {
        let calendar = Calendar.current
        
        guard let lastWeekStartDate = calendar.date(byAdding: .weekOfYear, value: -1, to: selectedDate),
              let lastWeekEndDate = calendar.date(byAdding: .day, value: -1, to: lastWeekStartDate) else {
            return
        }
        
        guard let adjustedStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: lastWeekStartDate)) else {
            return
        }
        
        let dataForLastWeek = getDataForLastWeek(startDate: adjustedStartDate, endDate: lastWeekEndDate)
        
        for (dayIndex, dayData) in dataForLastWeek.enumerated() {
            LastweakMyAvgData[dayIndex].data = dayData.data
        }
    }
    
    func getDataForLastWeek(startDate: Date, endDate: Date) -> [AgeWeakAvg] {
        var dataForLastWeek: [AgeWeakAvg] = []
        let calendar = Calendar.current
        
        for dayIndex in 0..<7 {
            guard let startOfDay = calendar.date(byAdding: .day, value: dayIndex, to: startDate),
                  let endOfDay = calendar.date(byAdding: .day, value: dayIndex, to: startDate) else {
                continue
            }
            
            let dataForDay = runningLog.filter {
                calendar.isDate($0.timestamp, inSameDayAs: startOfDay)
            }
            
            if !dataForDay.isEmpty {
                let totalDistance = dataForDay.reduce(0.0) { $0 + $1.distance }
                let averageDistance = totalDistance / Double(dataForDay.count)
                dataForLastWeek.append(AgeWeakAvg(weak: calendar.shortWeekdaySymbols[dayIndex], data: averageDistance))
            } else {
                dataForLastWeek.append(AgeWeakAvg(weak: calendar.shortWeekdaySymbols[dayIndex], data: 0))
            }
        }
        
        return dataForLastWeek
    }
    
}

extension GeoPoint {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
