//
//  RunningResultView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/05.
//

import SwiftUI

struct RunningResultView: View {
    @EnvironmentObject var router: Router
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapBoxMapView()
            
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
                                Text("4.3km / 3km")
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text("목표보다 1.3km 더 뛰었어요!")
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.fire)
                            VStack(alignment: .leading) {
                                Text("소모 칼로리")
                                Text("326 kcal / 300kcal")
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text("99 kcal 칼로리를 더 소모했어요!")
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.time)
                            VStack(alignment: .leading) {
                                Text("러닝 타임")
                                Text("00:15:00/ 00:15:32")
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text("예상 시간보다 00:32 단축 되었어요!")
                                .customFontStyle(.gray1_R12)
                        }
                        
                        HStack {
                            Image(.pace)
                            VStack(alignment: .leading) {
                                Text("페이스")
                                Text("-’--’’")
                                    .customFontStyle(.gray1_R14)
                            }
                            Spacer()
                            Text("평균 페이스 피드백 메세지")
                                .customFontStyle(.gray1_R12)
                        }
                    }
                    
                    VStack {
                        Text("좋아요! 당신의 러닝 성과가 빠르게 향상되고 있습니다. 안전을 위해 느긋한 페이스로 운동을 유지하고, 부상 없이 목표를 달성하세요.")
                            .customFontStyle(.gray1_R14)
                    }
                    
                    MainButton(buttonText: "리포트로 이동하기", action: {router.popToRoot()})
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
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    RunningResultView()
}
