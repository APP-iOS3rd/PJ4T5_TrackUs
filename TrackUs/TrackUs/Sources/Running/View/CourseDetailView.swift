//
//  CourseDetailView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI
import MapboxMaps

struct CourseDetailView: View {
    // 더미데이터 삭제예정
    let coordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.566637, longitude: 126.97338),
        CLLocationCoordinate2D(latitude: 37.566337, longitude: 126.97338),
        CLLocationCoordinate2D(latitude: 37.566637, longitude: 126.97328),
        CLLocationCoordinate2D(latitude: 37.566647, longitude: 126.97248),
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                RouteMapView(coordinates: coordinates, mapType: .pointer)
                    .frame(height: 230)
                    .preventGesture()
                
                VStack(spacing: 0)   {
                    courseDetail
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
    // 상세 운동정보
    var courseDetail: some View {
        HStack {
            Spacer()
            VStack {
                Image(.fire)
                Text("예상 소모 칼로리")
                    .foregroundStyle(Color.init(hex: 0x3d3d3d))
                Text("326 kcal")
                    .customFontStyle(.gray1_R14)
            }
            Spacer()
            VStack {
                Image(.time)
                Text("예상 소요 시간")
                    .foregroundStyle(Color.init(hex: 0x3d3d3d))
                Text("00:30:00")
                    .customFontStyle(.gray1_R14)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .modifier(BorderLineModifier())
    }
    
    // 제목, 부가설명 등등
    var courseDetailLabels: some View {
        VStack {
            HStack {
                Text("2024.01.12")
                    .customFontStyle(.gray2_R12)
                Spacer()
                RunningStyleBadge(style: .running)
            }
            
            VStack(alignment: .leading) {
                Text("30분 가볍게 러닝해요!")
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
                
            Text("서울숲카페거리에서 오전 10시 20분에 가볍게 30분정도 러닝하실 분을 모집합니다! 함께 재미있게 뛰어봐요! :)")
                    .customFontStyle(.gray1_R14)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // 참여자 리스트
    var participantList: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 2) {
                Text("4명").customFontStyle(.main_B14)
                Text("의 TrackUS 회원이 이 러닝 모임에 참여중입니다!")
                    .customFontStyle(.gray2_R14)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(1..<4, id: \.self) { _ in
                        UserProfileCell()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CourseDetailView()
}
