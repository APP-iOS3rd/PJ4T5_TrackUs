//
//  CourseDetailView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI
import MapboxMaps

struct CourseDetailView: View {
    @EnvironmentObject var router: Router
    
    let course: Course
    // 더미데이터 삭제예정
    
    var body: some View {
        VStack {
            PathPreviewMap(
                mapStyle: .numberd,
                coordinates: course.coordinates
            )
                .frame(height: 230)
            
            ScrollView {   
                VStack(spacing: 0)   {
                    RunningStatsView(estimatedTime: 1423.0, calories: 323.0, distance: 3.0)
                        .padding(.top, 20)
                    
                    courseDetailLabels
                        .padding(.top, 20)
                    
                    participantList
                        .padding(.top, 20)
                    
                }
                .padding(.horizontal, 16)
            }
            MainButton(buttonText: "트랙 참가하기") {
                
            }
            .padding(.horizontal, 16)
        }
        .customNavigation {
            NavigationText(title: "모집글 상세보기")
        } left: {
            NavigationBackButton()
        }
        
    }
}

extension CourseDetailView {
    
    // 제목, 부가설명 등등
    var courseDetailLabels: some View {
        VStack {
            HStack {
                Text(course.startDate.formattedString())
                    .customFontStyle(.gray2_R12)
                Spacer()
                RunningStyleBadge(style: .init(rawValue: course.runningStyle) ?? .running)
            }
            
            VStack(alignment: .leading) {
                Text(course.title)
                    .customFontStyle(.gray1_B20)
                
                HStack(spacing: 10) {
                    HStack {
                        Image(.pin)
                        
                        Text("서울숲 카페거리")
                            .customFontStyle(.gray1_R12)
                            .lineLimit(1)
                    }
                    HStack {
                        Image(.timerLine)
                        Text("10:02 AM")
                            .customFontStyle(.gray1_R12)
                    }
                    HStack {
                        Image(.arrowBoth)
                        Text("1.72km")
                            .customFontStyle(.gray1_R12)
                    }
                }
                
                Text(course.content)
                    .customFontStyle(.gray1_R14)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // 참여자 리스트
    var participantList: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 2) {
                Text("\(course.members.count)명").customFontStyle(.main_B14)
                Text("의 TrackUS 회원이 이 러닝 모임에 참여중입니다!")
                    .customFontStyle(.gray2_R14)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(course.members, id: \.self) { userId in
                        Button(action: {
                            router.push(.userProfile(userId))
                        }, label: {
                            UserProfileCell()
                        })
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

