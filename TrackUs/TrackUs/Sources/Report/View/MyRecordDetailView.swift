//
//  MyRecordDetailView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/14.
//

import SwiftUI
import MapboxMaps

struct MyRecordDetailView: View {
    let settingViewModel = SettingPopupViewModel()
    let runningLog: Runninglog
    private let exerciseManager: ExerciseManager!
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel = ReportViewModel.shared
    
    @State private var isOpen: Bool = true
    @State private var maxHeight: Double = 0.0
    @State private var minHeight: Double = 80.0
    
    init(viewModel: ReportViewModel = ReportViewModel.shared, runningLog: Runninglog) {
        self.viewModel = viewModel
        self.runningLog = runningLog
        self.exerciseManager = ExerciseManager(
            distance: runningLog.distance,
            target: runningLog.targetDistance ?? 0,
            elapsedTime: runningLog.elapsedTime
        )
    }
    
    var body: some View {
        
        ZStack {
            GeometryReader { geometry in
                PathPreviewMap(coordinates: runningLog.coordinates?.toCLLocationCoordinate2D() ?? [])
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
                                Text(runningLog.title ?? "러닝")
                                    .customFontStyle(.gray1_SB16)
                                Spacer()
                                Text(runningLog.isGroup ?? false ? "러닝메이트" : "개인")
                                    .foregroundColor(.white)
                                    .font(.system(size: 11))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 3)
                                    .background(runningLog.isGroup ?? false ? .orange2 : .main)
                                    .clipShape(Capsule())
                            }
                            
                            Text(runningLog.timestamp.formattedString())
                                .customFontStyle(.gray1_SB12)
                            
                            HStack {
                                Label(runningLog.address ?? "대한민국 서울시", image: "Pin")
                                    .customFontStyle(.gray1_R12)
                                
                                Label(runningLog.timestamp.formattedString(style: .time), image: "timerLine") //
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
                                    Text(exerciseManager.compareKilometers)
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text(exerciseManager.compareKilometersLabel)
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.fire)
                                VStack(alignment: .leading) {
                                    Text("소모 칼로리")
                                    
                                    Text(exerciseManager.compareCalories)
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text(exerciseManager.compareCaloriesLabel)
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.time)
                                VStack(alignment: .leading) {
                                    Text("러닝 타임")
                                    
                                    Text(exerciseManager.compareEstimatedTime)
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text(exerciseManager.compareEstimatedTimeLabel)
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            HStack {
                                Image(.pace)
                                VStack(alignment: .leading) {
                                    Text("페이스")
                                    Text(runningLog.pace.asString(unit: .pace))
                                        .customFontStyle(.gray1_R14)
                                }
                                Spacer()
                                Text("-")
                                    .customFontStyle(.gray1_R12)
                            }
                        }
                        HStack {
                            
                            Text(exerciseManager.feedbackMessageLabel)
                                .customFontStyle(.gray1_R14)
                                .lineLimit(3)
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
    
}


