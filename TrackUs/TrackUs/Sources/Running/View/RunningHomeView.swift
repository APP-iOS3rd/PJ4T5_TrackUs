//
//  RunningHomeView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/04.
//

import SwiftUI
import PopupView

struct RunningHomeView: View {
    @State private var isOpen: Bool = false
    @State private var maxHeight: CGFloat = 300
    @State private var showingPopup = false
    @State private var showingFloater = true
    
    var body: some View {
        ZStack {
            MapBoxMapView()
            
            BottomSheet(isOpen: $isOpen, maxHeight: maxHeight + 40, minHeight: 100) {
                VStack(spacing: 20) {
                    // MARK: - 프로필 & 러닝 시작
                    VStack {
                        HStack {
                            Image("ProfileDefault")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text("TrackUs님!")
                                    .customFontStyle(.gray1_B16)
                                
                                Text("페이스 같은 건 잊고 그냥 달려보세요.")
                                    .customFontStyle(.gray1_R12)
                            }
                            
                            Spacer()
                            
                            
                            Circle()
                                .fill(.white.shadow(.drop(color: .divider, radius: 10)))
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Image("Setting")
                                )
                                .onTapGesture {
                                    showingPopup = true
                                }
                            
                            
                            
                            NavigationLink(value: "RunningLiveView", label: {
                                Text("러닝 시작")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 12, weight: .bold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                            })
                            .background(.main)
                            .clipShape(Capsule())
                            
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
                        
                        Divider()
                            .background(.divider)
                    }
                    
                    
                    // MARK: - 내주변 러닝메이트
                    VStack(spacing: 16) {
                        HStack {
                            Image("SmallFire")
                                .resizable()
                                .frame(width: 38, height: 38)
                            
                            VStack(alignment: .leading) {
                                Text("혼자 하는 러닝이 지루하다면?")
                                    .customFontStyle(.gray1_B16)
                                
                                Text("내 근처 러닝메이트와 함께 러닝을 진행해보세요!")
                                    .customFontStyle(.gray1_R12)
                            }
                            .padding(.leading, 8)
                            Spacer()
                        }
                        .padding(.horizontal, Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
                        // 가로 스크롤
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                RunningRecruitmentCell()
                                RunningRecruitmentCell()
                                RunningRecruitmentCell()
                                RunningRecruitmentCell()
                            }
                            .padding(10)
                        }
                        .padding(.leading, 6)
                    }
                    
                    // MARK: - 러닝 리포트 확인하기
                    VStack {
                        NavigationLinkCard(title: "러닝 리포트 확인하기", subTitle: "러닝 거리, 통계, 달성 기록을 확인할 수 있습니다.")
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.gray3, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
                    
                }
                .background(
                    GeometryReader { innerGeometry in
                        Color.clear
                            .onAppear {
                                self.maxHeight = innerGeometry.size.height
                            }
                    }
                )
                
            }
            
        }
        .popup(isPresented: $showingFloater) {
            NavigationLinkCard(title: "혼자 러닝하기 지루할때는?", subTitle: "이 곳에서 러닝 메이트를 모집해보세요!")
                .cornerRadius(12)
                .padding(.horizontal, 16)

        } customize: {
            $0
                .type(.floater(verticalPadding: UIApplication.shared.statusBarFrame.size.height + 5, horizontalPadding: 16, useSafeAreaInset: true))
                .position(.top)
                .animation(.spring())
        }
        .popup(isPresented: $showingPopup) {
            SettingPopup(showingPopup: $showingPopup)
        } customize: {
            $0
                .backgroundColor(.black.opacity(0.3))
                .isOpaque(true)
                .dragToDismiss(false)
                .closeOnTap(false)
        }
        .navigationDestination(for: String.self, destination: { screenName in
            switch screenName {
            case "RunningLiveView":
                RunningLiveView()
            default:
                EmptyView()
            }
        })
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    RunningHomeView()
}
