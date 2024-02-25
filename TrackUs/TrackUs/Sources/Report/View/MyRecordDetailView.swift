//
//  MyRecordDetailView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/14.
//

import SwiftUI
import MapboxMaps

struct MyRecordDetailView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel = ReportViewModel.shared
    let settingViewModel = SettingPopupViewModel()
    @State private var isOpen: Bool = true
    @State private var maxHeight: Double = 0.0
    @State private var minHeight: Double = 80.0
    
    let runningLog: Runninglog?
    
    var body: some View {
        
        // TODO: - 여러곳에서 사용할 수 있도록 로직분리
        var estimatedCalories: Double {
            return ExerciseManager.calculatedCaloriesBurned(distance: settingViewModel.goalMinValue, totalTime: Double(settingViewModel.estimatedTime) * 60)
        }
        
        var estimatedTimeText: String {
            return  Double(settingViewModel.estimatedTime * 60).asString(style: .positional)
        }
        
        var feedbackMessageLabel: String {
            let estimatedTime = Double(settingViewModel.estimatedTime) // 예상시간
            let distanceInKilometers = runningLog!.distance // 킬로미터
            let goalDistance = Double(settingViewModel.goalMinValue) // 목표치
            let goalReached = distanceInKilometers >= goalDistance // 목표도달 여부
            let timeReduction = runningLog!.elapsedTime < estimatedTime // 시간단축 여부
            
            if goalReached, timeReduction {
                return "대단해요! 목표를 달성하고 도전 시간을 단축했어요. 지속적인 노력이 효과를 나타내고 있습니다. 계속해서 도전해보세요!"
            }
            else if !goalReached, timeReduction {
                return "목표에는 도달하지 못했지만, 러닝 시간을 단축했어요! 훌륭한 노력입니다. 계속해서 노력하면 목표에 더 가까워질 거에요!"
            }
            else if goalReached, !timeReduction {
                return "목표에 도달했어요! 비록 러닝 시간을 단축하지 못했지만, 목표를 이루다니 정말 멋져요. 지속적인 노력으로 시간을 줄여가는 모습을 기대해봅니다!"
            } else {
                return "목표에 도달하지 못했어도 괜찮아요. 중요한 건 노력한 자체입니다. 목표와 거리를 조금 낮춰서 차근차근 도전해보세요!"
            }
        }
        
        // 목표값과 비교하여 수치로 알려줌
        var elapsedTimeDifferenceLabel: String {
            let differenceInSeconds = Double(settingViewModel.estimatedTime * 60) - runningLog!.elapsedTime
            if differenceInSeconds > 0  {
                return "예상 시간보다 \(differenceInSeconds.asString(style: .positional)) 빨리 끝났어요!"
            } else {
                return "예상 시간보다 \(abs(differenceInSeconds).asString(style: .positional)) 늦게 끝났어요"
            }
        }
        
        var kilometerDifferenceLabel: String {
            let difference = (runningLog!.distance) - settingViewModel.goalMinValue
            if difference > 0 {
                return "목표보다 \(difference.asString(unit: .kilometer)) 더 뛰었어요!"
            } else {
                return "목표보다 \(abs(difference).asString(unit: .kilometer)) 덜 뛰었어요."
            }
        }
        
        var calorieDifferenceLabel: String {
            let difference = (runningLog!.calorie) - estimatedCalories
            if difference > 0 {
                return "\(difference.asString(unit: .calorie))를 더 소모했어요!"
            } else {
                return "\(abs(difference).asString(unit: .calorie))를 덜 소모했어요."
            }
        }
        
        // 실제기록/예상목표
        var kilometerComparisonLabel: String {
            "\(runningLog!.distance.asString(unit: .kilometer)) / \(settingViewModel.goalMinValue.asString(unit: .kilometer))"
        }
        
        var calorieComparisonLabel: String {
            "\(runningLog!.calorie.asString(unit: .calorie)) / \(estimatedCalories.asString(unit: .calorie))"
        }
        
        var timeComparisonLabel: String {
            "\(runningLog!.elapsedTime.asString(style: .positional)) / \(Double(settingViewModel.estimatedTime * 60).asString(style: .positional))"
        }
        // 맵뷰(임시)
        ZStack {
            GeometryReader { geometry in
                PathPreviewMap(coordinates: runningLog?.coordinates?.map { $0.toCLLocationCoordinate2D() } ?? [])
                
                    .onTapGesture {
                        withAnimation {
                            isOpen = false
                        }
                    }
                
                BottomSheet(isOpen: $isOpen, maxHeight: maxHeight, minHeight: minHeight) {
                    VStack(spacing: 20) {
                        // 제목, 날짜, 위치
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                //                            Text("서울숲 카페거리 러닝메이트") // ReportViewModel의 title
                                Text(runningLog?.title ?? "러닝") // ReportViewModel의 title
                                    .customFontStyle(.gray1_SB16)
                                Spacer()
                                Text("개인")
                                    .foregroundColor(.white)
                                    .font(.system(size: 11))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 3)
                                    .background(Color.main)
                                    .clipShape(Capsule())
                            }
                            
                            //                        Text("2024년 02월 13일") // ReportViewModel의 timestamp
                            //                            Text("\(runningLog?.timestamp ?? Date())") // ReportViewModel의 timestamp
                            Text(formatDate(runningLog?.timestamp ?? Date())) // ReportViewModel의 timestamp
                                .customFontStyle(.gray1_SB12)
                            
                            HStack {
                                //                            Label("서울숲 카페거리", image: "Pin") // ReportViewModel의 address
                                Label(runningLog?.address ?? "대한민국 서울시", image: "Pin") // ReportViewModel의 address
                                    .customFontStyle(.gray1_R12)
                                
                                //                            Label("10:02 AM", image: "timerLine") // ReportViewModel의 timestamp
                                //                                Label("\(runningLog?.timestamp ?? Date())", image: "timerLine") // ReportViewModel의 timestamp
                                Label(formatTime(runningLog?.timestamp ?? Date()), image: "timerLine") // ReportViewModel의 timestamp
                                    .customFontStyle(.gray1_R12)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // 운동량
                        VStack(alignment: .leading, spacing: 20) {
                            Text("운동량")
                                .customFontStyle(.gray1_R16)
                            
                            HStack {
                                Image(.shose)
                                VStack(alignment: .leading) {
                                    Text("킬로미터")
                                    //                                Text("-") // ReportViewModel의 distance
//                                    Text("\((runningLog?.distance ?? 0) / 1000.0, specifier: "%.2f")km") // ReportViewModel의 distance
                                    Text(kilometerComparisonLabel) // ReportViewModel의 distance
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text(kilometerDifferenceLabel)
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.fire)
                                VStack(alignment: .leading) {
                                    Text("소모 칼로리")
                                    //                                Text("-") // ReportViewModel의 calorie
                                    Text(calorieComparisonLabel) // ReportViewModel의 calorie
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text(calorieDifferenceLabel)
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.time)
                                VStack(alignment: .leading) {
                                    Text("러닝 타임")
                                    //                                Text("-") // ReportViewModel의 elapsedTime
                                    Text(timeComparisonLabel) // ReportViewModel의 elapsedTime
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text(elapsedTimeDifferenceLabel)
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.pace)
                                VStack(alignment: .leading) {
                                    Text("페이스")
                                    //                                Text("-") // ReportViewModel의 pace
                                    Text(runningLog!.pace.asString(unit: .pace)) // ReportViewModel의 pace
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text("-")
                                    .customFontStyle(.gray1_R12)
                            }
                        }
                        
                        // 피드백
                        HStack {
//                            Text("피드백 메세지")
                            Text(feedbackMessageLabel)
                                .customFontStyle(.gray1_R14)
                                .lineLimit(3)
//                            Spacer()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
                    .background(
                        GeometryReader { innerGeometry in
                            Color.clear
                                .onAppear {
                                    self.maxHeight = innerGeometry.size.height + 44
                                }
                        }
                    )
                    .gesture(DragGesture()
                        .onEnded({ (gesture) in
                            if gesture.translation.width > 100 {
                                router.pop()
                            }
                        }))
                }
                
                
            onChanged: { _ in}
            onEnded: { _ in }
                
            }
            .customNavigation {
                NavigationText(title: "러닝기록")
            } left: {
                NavigationBackButton()
            }
        }
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

//MARK: -

struct MyMateRecordDetailView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel = ReportViewModel.shared
    let settingViewModel = SettingPopupViewModel()
    @State private var isOpen: Bool = true
    @State private var maxHeight: Double = 0.0
    @State private var minHeight: Double = 80.0
    
    let runningLog: Runninglog?
    
    var body: some View {
        
        // TODO: - 여러곳에서 사용할 수 있도록 로직분리
        var estimatedCalories: Double {
            return ExerciseManager.calculatedCaloriesBurned(distance: settingViewModel.goalMinValue, totalTime: Double(settingViewModel.estimatedTime) * 60)
        }
        
        var estimatedTimeText: String {
            return  Double(settingViewModel.estimatedTime * 60).asString(style: .positional)
        }
        
        var feedbackMessageLabel: String {
            let estimatedTime = Double(settingViewModel.estimatedTime) // 예상시간
            let distanceInKilometers = runningLog!.distance // 킬로미터
            let goalDistance = Double(settingViewModel.goalMinValue) // 목표치
            let goalReached = distanceInKilometers >= goalDistance // 목표도달 여부
            let timeReduction = runningLog!.elapsedTime < estimatedTime // 시간단축 여부
            
            if goalReached, timeReduction {
                return "대단해요! 목표를 달성하고 도전 시간을 단축했어요. 지속적인 노력이 효과를 나타내고 있습니다. 계속해서 도전해보세요!"
            }
            else if !goalReached, timeReduction {
                return "목표에는 도달하지 못했지만, 러닝 시간을 단축했어요! 훌륭한 노력입니다. 계속해서 노력하면 목표에 더 가까워질 거에요!"
            }
            else if goalReached, !timeReduction {
                return "목표에 도달했어요! 비록 러닝 시간을 단축하지 못했지만, 목표를 이루다니 정말 멋져요. 지속적인 노력으로 시간을 줄여가는 모습을 기대해봅니다!"
            } else {
                return "목표에 도달하지 못했어도 괜찮아요. 중요한 건 노력한 자체입니다. 목표와 거리를 조금 낮춰서 차근차근 도전해보세요!"
            }
        }
        
        // 목표값과 비교하여 수치로 알려줌
        var elapsedTimeDifferenceLabel: String {
            let differenceInSeconds = Double(settingViewModel.estimatedTime * 60) - runningLog!.elapsedTime
            if differenceInSeconds > 0  {
                return "예상 시간보다 \(differenceInSeconds.asString(style: .positional)) 빨리 끝났어요!"
            } else {
                return "예상 시간보다 \(abs(differenceInSeconds).asString(style: .positional)) 늦게 끝났어요"
            }
        }
        
        var kilometerDifferenceLabel: String {
            let difference = (runningLog!.distance) - settingViewModel.goalMinValue
            if difference > 0 {
                return "목표보다 \(difference.asString(unit: .kilometer)) 더 뛰었어요!"
            } else {
                return "목표보다 \(abs(difference).asString(unit: .kilometer)) 덜 뛰었어요."
            }
        }
        
        var calorieDifferenceLabel: String {
            let difference = (runningLog!.calorie) - estimatedCalories
            if difference > 0 {
                return "\(difference.asString(unit: .calorie))를 더 소모했어요!"
            } else {
                return "\(abs(difference).asString(unit: .calorie))를 덜 소모했어요."
            }
        }
        
        // 실제기록/예상목표
        var kilometerComparisonLabel: String {
            "\(runningLog!.distance.asString(unit: .kilometer)) / \(settingViewModel.goalMinValue.asString(unit: .kilometer))"
        }
        
        var calorieComparisonLabel: String {
            "\(runningLog!.calorie.asString(unit: .calorie)) / \(estimatedCalories.asString(unit: .calorie))"
        }
        
        var timeComparisonLabel: String {
            "\(runningLog!.elapsedTime.asString(style: .positional)) / \(Double(settingViewModel.estimatedTime * 60).asString(style: .positional))"
        }
        // 맵뷰(임시)
        ZStack {
            GeometryReader { geometry in
                PathPreviewMap(coordinates: runningLog?.coordinates?.map { $0.toCLLocationCoordinate2D() } ?? [])
                    .onTapGesture {
                        withAnimation {
                            isOpen = false
                        }
                    }
                
                BottomSheet(isOpen: $isOpen, maxHeight: maxHeight, minHeight: minHeight) {
                    VStack(spacing: 20) {
                        // 제목, 날짜, 위치
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                //                            Text("서울숲 카페거리 러닝메이트") // ReportViewModel의 title
                                Text(runningLog?.title ?? "러닝") // ReportViewModel의 title
                                    .customFontStyle(.gray1_SB16)
                                Spacer()
                                Text("러닝메이트")
                                    .foregroundColor(.white)
                                    .font(.system(size: 11))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 3)
                                    .background(Color.orange2)
                                    .clipShape(Capsule())
                            }
                            
                            //                        Text("2024년 02월 13일") // ReportViewModel의 timestamp
                            //                            Text("\(runningLog?.timestamp ?? Date())") // ReportViewModel의 timestamp
                            Text(formatDate(runningLog?.timestamp ?? Date())) // ReportViewModel의 timestamp
                                .customFontStyle(.gray1_SB12)
                            
                            HStack {
                                //                            Label("서울숲 카페거리", image: "Pin") // ReportViewModel의 address
                                Label(runningLog?.address ?? "대한민국 서울시", image: "Pin") // ReportViewModel의 address
                                    .customFontStyle(.gray1_R12)
                                
                                //                            Label("10:02 AM", image: "timerLine") // ReportViewModel의 timestamp
                                //                                Label("\(runningLog?.timestamp ?? Date())", image: "timerLine") // ReportViewModel의 timestamp
                                Label(formatTime(runningLog?.timestamp ?? Date()), image: "timerLine") // ReportViewModel의 timestamp
                                    .customFontStyle(.gray1_R12)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("참여 러닝메이트")
                                .customFontStyle(.gray1_R16)
                            
                            ScrollView(.horizontal) {
                                HStack { // 러닝 인원
                                    ForEach(0..<5) { item in
                                        VStack {
                                            Circle() // 해당사용자 이미지
                                                .frame(width: 30, height: 30)
                                            
                                            Text("사용자이름") // 해당 사용자 이름
                                                .customFontStyle(.gray1_R12)
                                            Text("12KM") // 해당 사용자 러닝거리
                                                .customFontStyle(.gray1_SB12)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // 운동량
                        VStack(alignment: .leading, spacing: 20) {
                            Text("운동량")
                                .customFontStyle(.gray1_R16)
                            
                            HStack {
                                Image(.shose)
                                VStack(alignment: .leading) {
                                    Text("킬로미터")
                                    //                                Text("-") // ReportViewModel의 distance
//                                    Text("\((runningLog?.distance ?? 0) / 1000.0, specifier: "%.2f")km") // ReportViewModel의 distance
                                    Text(kilometerComparisonLabel) // ReportViewModel의 distance
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text(kilometerDifferenceLabel)
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.fire)
                                VStack(alignment: .leading) {
                                    Text("소모 칼로리")
                                    //                                Text("-") // ReportViewModel의 calorie
                                    Text(calorieComparisonLabel) // ReportViewModel의 calorie
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text(calorieDifferenceLabel)
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.time)
                                VStack(alignment: .leading) {
                                    Text("러닝 타임")
                                    //                                Text("-") // ReportViewModel의 elapsedTime
                                    Text(timeComparisonLabel) // ReportViewModel의 elapsedTime
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text(elapsedTimeDifferenceLabel)
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.pace)
                                VStack(alignment: .leading) {
                                    Text("페이스")
                                    //                                Text("-") // ReportViewModel의 pace
                                    Text(runningLog!.pace.asString(unit: .pace)) // ReportViewModel의 pace
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text("-")
                                    .customFontStyle(.gray1_R12)
                            }
                        }
                        
                        // 피드백
                        HStack {
//                            Text("피드백 메세지")
                            Text(feedbackMessageLabel)
                                .customFontStyle(.gray1_R14)
                                .lineLimit(3)
//                            Spacer()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
                    .background(
                        GeometryReader { innerGeometry in
                            Color.clear
                                .onAppear {
                                    self.maxHeight = innerGeometry.size.height + 44
                                }
                        }
                    )
                    .gesture(DragGesture()
                        .onEnded({ (gesture) in
                            if gesture.translation.width > 100 {
                                router.pop()
                            }
                        }))
                }
                
                
            onChanged: { _ in}
            onEnded: { _ in }
                
            }
            .customNavigation {
                NavigationText(title: "러닝기록")
            } left: {
                NavigationBackButton()
            }
        }
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
