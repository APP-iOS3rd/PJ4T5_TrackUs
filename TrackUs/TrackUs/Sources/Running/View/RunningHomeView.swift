//
//  RunningHomeView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/04.
//

import SwiftUI
import PopupView
import Kingfisher

struct RunningHomeView: View {
    @EnvironmentObject var router: Router
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @StateObject var courseListViewModel = CourseListViewModel()
    @StateObject var userSearchViewModel = UserSearchViewModel()
    @State private var isOpen: Bool = false
    @State private var showingPopup: Bool = false
    @State private var showingFloater: Bool = true
    @State private var showingAlert: Bool = false
    @State private var offset: CGFloat = 0
    @State private var deltaY: CGFloat = 0
    
    let cheeringPhrase = [
        "나만의 페이스로, 나만의 피니쉬라인까지.",
        "걸음마다 성장이 느껴지는 곳, 함께 뛰어요!",
        "새로운 기회는 당신의 발 아래에 있어요.",
        "나만의 런웨이에서 뛰어보세요."
    ].randomElement()!
}

// MARK: - View
extension RunningHomeView {
    var body: some View {
        GeometryReader { geometry in
            LocationMeMapView()
                .onTapGesture {
                    withAnimation {
                        isOpen = false
                    }
                    offset = 0
                }
                .frame(height: geometry.size.height - 95)
                .offset(y: min(offset, 0))
                .animation(.interactiveSpring(), value: offset)
                
            
            
            // MARK: - Sheet
            BottomSheet(isOpen: $isOpen, maxHeight: 580, minHeight: 100) {
                VStack(spacing: 20) {
                    
                    // 프로필 & 러닝시작
                    profileHeader
                        .padding(.horizontal, 16)
                    
                    // 내주변 러닝메이트
                    runningAroundMe
                    
                    // 러닝 리포트 확인하기
                    GraphicTextCard(title: "러닝 리포트 확인하기", subTitle: "러닝 거리, 통계, 달성 기록을 확인할 수 있습니다.", resource: .clipboard)
                        .modifier(BorderLineModifier())
                        .padding(.horizontal, 16)
                }
            } onChanged: { gestureValue in
                let newDeltaY = gestureValue.translation.height
                let deltaHeight = abs(abs(newDeltaY) - abs(deltaY))
                let endPoint = geometry.size.height * 0.3 // 3분의 1을 넘어가는 지점에서 종료
                
                if newDeltaY < deltaY && offset > -endPoint  {
                    offset -=  deltaHeight
                } else if newDeltaY > deltaY {
                    offset += deltaHeight
                }
                
                deltaY = gestureValue.translation.height
                
            } onEnded: { _ in
                let endPoint = geometry.size.height * 0.3
                
                if isOpen {
                    offset = -endPoint
                } else {
                    offset = 0
                }
                deltaY = 0
            }
        }
        .onAppear {
            courseListViewModel.fetchCourseData()
        }
        // MARK: - 상단 팝업
              .popup(isPresented: $showingFloater) {
                  Button(action: {
                      router.push(.courseDrawing)
                  }) {
                      GraphicTextCard(title: "내가 만드는 러닝코스", subTitle: "나만의 코스를 그리고 다른 러너와 함께 뛰어보세요!", resource: .pen)
                          .cornerRadius(12)
                          .padding(.horizontal, 16)
                  }
                  
              } customize: {
                  $0
                      .type(.floater(verticalPadding: UIApplication.shared.statusBarFrame.size.height + 5, horizontalPadding: 16, useSafeAreaInset: true))
                      .position(.top)
                      .animation(.spring())
                      .closeOnTap(false)
              }
        .edgesIgnoringSafeArea(.top)
        
    }
}

// MARK: - SubView's
extension RunningHomeView {
    // 프로필 헤더
    var profileHeader: some View {
        VStack {
            HStack {
                KFImage(URL(string: authViewModel.userInfo.profileImageUrl ?? ""))
                    .placeholder({ProgressView()})
                    .onFailureImage(KFCrossPlatformImage(named: "ProfileDefault"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("\(authViewModel.userInfo.username)님!")
                        .customFontStyle(.gray1_B16)
                    
                    Text(cheeringPhrase)
                        .customFontStyle(.gray1_R12)
                }
                
                Spacer()
                
                Button(action: startButtonTapped, label: {
                    Text("러닝 시작")
                        .foregroundStyle(.white)
                        .font(.system(size: 12, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                })
                .background(.main)
                .clipShape(Capsule())
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("러닝을 시작하기 위해서 앱에서 위치를 엑세스할 수 있도록 허용해 주세요."),
                        message: Text("러닝을 추적하고 그 외 다른 서비스와 기능을 이용하기 위해서 정확한 위치 정보가 필요합니다."),
                        primaryButton: .destructive (
                            Text("취소"),
                            action: { }
                        ),
                        secondaryButton: .default (
                            Text("설정"),
                            action: {
                                if let appSettings = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
                                    UIApplication.shared.open(appSettings,options: [:],completionHandler: nil)
                                }
                            }
                        )
                    )
                }
            }
            .padding(.vertical, 10)
            Divider()
                .background(.divider)
        }
    }
    
    // 내주변 러닝
    var runningAroundMe: some View {
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
            if !courseListViewModel.courseList.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack {
                        HStack(spacing: 12) {
                            ForEach(courseListViewModel.courseList, id: \.self) { course in
                                Button(action: {
                                    router.push(.courseDetail(CourseViewModel(course: course)))
                                }, label: {
                                    RunningRecruitmentCell(course: course, user: userSearchViewModel.filterdUserData(uid: [course.ownerUid])[0])
                                })
                            }
                            
                        }
                    }
                    .padding(.vertical, 8)
                }
                .padding(.leading, 16)
            } else {
                AroundMePlacholderView()
            }
            
        }
    }
}

// MARK: - Method's
extension RunningHomeView {
    func startButtonTapped() {
        LocationManager.shared.checkLocationServicesEnabled { authrionzationStatus in
            if authrionzationStatus == .authorizedWhenInUse {
                router.push(.runningSelect)
            } else {
                showingAlert = true
            }
        }
    }
}
