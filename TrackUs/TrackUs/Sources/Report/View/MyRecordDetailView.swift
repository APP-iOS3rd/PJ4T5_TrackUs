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
    @State private var isOpen: Bool = true
    @State private var maxHeight: Double = 0.0
    @State private var minHeight: Double = 80.0
    
    let runningLog: Runninglog?
    
    var body: some View {
        // 맵뷰(임시)
        ZStack {
            GeometryReader { geometry in
//                RouteMapView(lineCoordinates: [CLLocationCoordinate2D(latitude: CLLocationDegrees(floatLiteral: 37.558177), longitude: CLLocationDegrees(floatLiteral: 126.997408))]) // ReportViewModel의 coordinates
                RouteMapView(lineCoordinates: runningLog?.coordinates?.map { $0.toCLLocationCoordinate2D() } ?? [])
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
                                    Text("\((runningLog?.distance ?? 0) / 1000.0, specifier: "%.2f")km") // ReportViewModel의 distance
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text("-")
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.fire)
                                VStack(alignment: .leading) {
                                    Text("소모 칼로리")
                                    //                                Text("-") // ReportViewModel의 calorie
                                    Text("\(runningLog?.calorie ?? 0, specifier: "%.1f")kcal") // ReportViewModel의 calorie
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text("-")
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.time)
                                VStack(alignment: .leading) {
                                    Text("러닝 타임")
                                    //                                Text("-") // ReportViewModel의 elapsedTime
                                    Text("\(runningLog?.elapsedTime.asString(style: .positional) ?? "00:00:00")") // ReportViewModel의 elapsedTime
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text("-")
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.pace)
                                VStack(alignment: .leading) {
                                    Text("페이스")
                                    //                                Text("-") // ReportViewModel의 pace
                                    Text("\(runningLog?.pace ?? 0)") // ReportViewModel의 pace
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text("-")
                                    .customFontStyle(.gray1_R12)
                            }
                        }
                        
                        // 피드백
                        HStack {
                            Text("피드백 메세지")
                                .customFontStyle(.gray1_R14)
                            Spacer()
                        }
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
                
//                Color.clear
//                    .customNavigation {
//                        NavigationText(title: "러닝기록")
//                    } left: {
//                        NavigationBackButton()
//                    }
            }
            
            Color.clear
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

//import SwiftUI
//import MapboxMaps
//
//struct MyRecordDetailView: View {
//    @State private var isOpen: Bool = true
//    @State private var maxHeight: Double = 0.0
//    @State private var minHeight: Double = 80.0
//    let runningLog: Runninglog?
//    
//    var body: some View {
//        GeometryReader { geometry in
//            // 맵뷰(임시)
//            RouteMapView(lineCoordinates: [CLLocationCoordinate2D(latitude: CLLocationDegrees(floatLiteral: 37.558177), longitude: CLLocationDegrees(floatLiteral: 126.997408))])
//                .onTapGesture {
//                    withAnimation {
//                        isOpen = false
//                    }
//                }
//            
//            BottomSheet(isOpen: $isOpen, maxHeight: maxHeight, minHeight: minHeight) {
//                VStack(spacing: 20) {
//                    // 제목, 날짜, 위치
//                    VStack(alignment: .leading, spacing: 4) {
//                        HStack {
//                            Text("서울숲 카페거리 러닝메이트")
//                                .customFontStyle(.gray1_SB16)
//                            Spacer()
//                            Text("개인")
//                                .foregroundColor(.white)
//                                .font(.system(size: 11))
//                                .fontWeight(.semibold)
//                                .padding(.horizontal, 9)
//                                .padding(.vertical, 3)
//                                .background(Color.main)
//                                .clipShape(Capsule())
//                        }
//                        
//                        Text("2024년 02월 13일")
//                            .customFontStyle(.gray1_SB12)
//                        
//                        HStack {
//                            Label("서울숲 카페거리", image: "Pin")
//                                .customFontStyle(.gray1_R12)
//                            
//                            Label("10:02 AM", image: "timerLine")
//                                .customFontStyle(.gray1_R12)
//                        }
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    // 운동량
//                    VStack(alignment: .leading, spacing: 20) {
//                        Text("운동량")
//                            .customFontStyle(.gray1_R16)
//                        
//                        HStack {
//                            Image(.shose)
//                            VStack(alignment: .leading) {
//                                Text("킬로미터")
//                                Text("-")
//                                    .customFontStyle(.gray1_R14)
//                            }
//                            Spacer()
//                            Text("-")
//                                .customFontStyle(.gray1_R12)
//                        }
//                        
//                        HStack {
//                            Image(.fire)
//                            VStack(alignment: .leading) {
//                                Text("소모 칼로리")
//                                Text("-")
//                                    .customFontStyle(.gray1_R14)
//                            }
//                            Spacer()
//                            Text("-")
//                                .customFontStyle(.gray1_R12)
//                        }
//                        
//                        HStack {
//                            Image(.time)
//                            VStack(alignment: .leading) {
//                                Text("러닝 타임")
//                                Text("-")
//                                    .customFontStyle(.gray1_R14)
//                            }
//                            Spacer()
//                            Text("-")
//                                .customFontStyle(.gray1_R12)
//                        }
//                        
//                        HStack {
//                            Image(.pace)
//                            VStack(alignment: .leading) {
//                                Text("페이스")
//                                Text("-")
//                                    .customFontStyle(.gray1_R14)
//                            }
//                            Spacer()
//                            Text("-")
//                                .customFontStyle(.gray1_R12)
//                        }
//                    }
//                    
//                    // 피드백
//                    HStack {
//                        Text("피드백 메세지")
//                            .customFontStyle(.gray1_R14)
//                        Spacer()
//                    }
//                }
//                .padding(Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
//                .background(
//                    GeometryReader { innerGeometry in
//                        Color.clear
//                            .onAppear {
//                                self.maxHeight = innerGeometry.size.height + 44
//                            }
//                    }
//                )
//            }
//        onChanged: { _ in}
//        onEnded: { _ in }
//            
//        }
//        .customNavigation {
//            NavigationText(title: "러닝기록")
//        } left: {
//            NavigationBackButton()
//        }
//        
//    }
//}

//#Preview {
//    MyRecordDetailView()
//}
