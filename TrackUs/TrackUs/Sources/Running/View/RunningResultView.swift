//
//  RunningResultView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct RunningResultView: View {
    @EnvironmentObject var router: Router
    let runningRecord: RunningRecord
    
    
    var body: some View {
        VStack {
            RouteMapView(lineCoordinates: runningRecord.coordinates)
                .offset(y: 15)
            VStack {
                VStack(spacing: 20) {
                    
                    RoundedRectangle(cornerRadius: 27)
                        .fill(.indicator)
                        .frame(
                            width: 32,
                            height: 4
                        )
                    
                    Text("러닝 결과")
                        .customFontStyle(.gray1_SB20)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("운동량")
                            .customFontStyle(.gray1_R16)
                        
                        HStack {
                            Image(.shose)
                            VStack(alignment: .leading) {
                                Text("킬로미터")
                                Text(String(format: "%.2f", runningRecord.distance / 1000.0) + " km / - ")
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
                                Text(String(format: "%.1f", runningRecord.calorie) + " kcal / - ")
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
                                Text("\(runningRecord.elapsedTime.asString(style: .positional))")
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
                                Text(runningRecord.paceMinutes == 0 && runningRecord.paceSeconds == 0 ? "-'--''" : String(format: "%2d'%02d''", runningRecord.paceMinutes, runningRecord.paceSeconds))
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text("-")
                                .customFontStyle(.gray1_R12)
                        }
                    }
                    
                    HStack {
                        Text("피드백 메세지 피드백 메세지피드백 메세지피드백 메세지피드백 메세지피드백 메세지피드백 메세지피드백 메세지피드백 메세지피드백 메세지")
                            .customFontStyle(.gray1_R14)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 28) {
                        MainButton(active: true, buttonText: "리포트로 이동하기", buttonColor: .gray1, minHeight: 45) {
                            router.popToRoot()
                        }
                        
                        MainButton(active: true, buttonText: "러닝 기록 저장", buttonColor: .main, minHeight: 45) {
                            router.popToRoot()
                        }
                    
                    }
                }
                .padding(20)
            }
            
            
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(
                .rect (
                    topLeadingRadius: 12,
                    topTrailingRadius: 12
                )
            )
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        .preventGesture()
    }
}

//#Preview {
//    RunningResultView()
//}
