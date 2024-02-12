//
//  RunningLiveView.swift
//  TrackUs
//
//  Created by 윤준성 on 2/4/24.
//

import SwiftUI
import MapboxMaps

struct RunningLiveView: View {
    @EnvironmentObject var router: Router
    @StateObject private var countVM = CountViewModel()
    @StateObject private var mapViewModel = MapViewModel()
    @GestureState private var press = false
    @State private var isPause = false
    @State private var isShowingMessage = false
    
    
    var body: some View {
        ZStack {
            MapViewRepresentable(mapViewModel: mapViewModel)
            
            Color.black
                .opacity(countVM.isHidden || isPause ? countVM.backgroundOpacity : 0.0)
            
            VStack {
                if countVM.isHidden {
                    Text("\(countVM.countdown)")
                        .font(.system(size: 128))
                        .italic()
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .onAppear {
                            countVM.startCountdown()
                        }
                    
                    Text("잠시후 러닝이 시작됩니다!")
                        .customFontStyle(.white_SB20)
                }
                else {
                    // 운동상태
                    VStack(spacing: 16) {
                        HStack {
                            Image(.shose)
                            Text("현재까지 거리")
                                .customFontStyle(.gray1_M16)
                            Spacer()
                            Text(String(format: "%.2f", mapViewModel.distance / 1000.0) + "km/0km")
                                .customFontStyle(.gray1_B20)
                                .italic()
                        }
                        .padding(16)
                        .background(.white)
                        .clipShape(Capsule())
                        
                        HStack {
                            VStack {
                                Image(.fire)
                                Text("소모 칼로리")
                                    .customFontStyle(.gray1_M16)
                                
                                Text("")
                                    .customFontStyle(.gray1_B20)
                                    .italic()
                            }
                            .frame(width: 100, height: 100)
                            .background(.white)
                            .clipShape(Circle())
                            
                            Spacer()
                            
                            VStack {
                                Image(.pace)
                                Text("페이스")
                                    .customFontStyle(.gray1_M16)
                                
                                Text("-'--''")
                                    .customFontStyle(.gray1_B20)
                                    .italic()
                            }
                            .frame(width: 100, height: 100)
                            .background(.white)
                            .clipShape(Circle())
                            
                            Spacer()
                            
                            VStack {
                                Image(.time)
                                Text("경과시간")
                                    .customFontStyle(.gray1_M16)
                                
                                Text("\(mapViewModel.elapsedTime.asString(style: .positional))")
                                    .customFontStyle(.gray1_B20)
                                    .italic()
                            }
                            .frame(width: 100, height: 100)
                            .background(.white)
                            .clipShape(Circle())
                            
                        }
                    }
                    .onReceive(mapViewModel.timer) { _ in
                        self.mapViewModel.elapsedTime += 1.0
                    }
                    .onAppear {
                        self.mapViewModel.startTracking()
                    }
                    .padding(.top, UIApplication.shared.statusBarFrame.size.height + 5)
                    .padding(.horizontal, Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
                    
                    Spacer()
                    VStack {
                        
                        if isPause {
                            VStack {
                                EmptyView()
                                    .popup(isPresented: $isShowingMessage) {
                                        HStack {
                                            Image(.power)
                                            VStack(alignment: .leading) {
                                                Text("러닝을 종료하실건가요?")
                                                    .customFontStyle(.gray1_B16)
                                                HStack {
                                                    Text("러닝 종료 버튼을")
                                                        .customFontStyle(.gray1_R14)
                                                    Text("2초간 TAB")
                                                        .font(.system(size: 14, weight: .bold))
                                                        .foregroundStyle(.main)
                                                    Text("해주세요!")
                                                        .customFontStyle(.gray1_R14)
                                                }
                                            }
                                            
                                        }
                                        .padding(12)
                                        .frame(maxWidth: .infinity)
                                        .background(.white)
                                        .clipShape(Capsule())
                                        
                                    } customize: {
                                        $0
                                            .type(.floater())
                                            .position(.bottom)
                                            .animation(.smooth)
                                            .autohideIn(2)
                                    }
                                HStack {
                                    Button(action: stopButtonTapped, label: {
                                        VStack {
                                            Image(systemName: "stop.fill")
                                                .foregroundStyle(.gray1)
                                                .font(.system(size: 55))
                                                .padding(27)
                                        }
                                        .background(.white)
                                        .clipShape(Circle())
                                    })
                                    .simultaneousGesture(LongPressGesture(minimumDuration: 2)
                                        .updating($press) { currentState, gestureState, transaction in
                                            gestureState = currentState
                                        }
                                        .onEnded(stopButtonLongPressed))
                                    .simultaneousGesture(TapGesture().onEnded(stopButtonTapped))
                                    
                                    Spacer()
                                    
                                    Button(action: playButtonTapped, label: {
                                        VStack {
                                            Image(systemName: "play.fill")
                                                .foregroundStyle(.gray1)
                                                .font(.system(size: 55))
                                                .padding(27)
                                        }
                                        .background(.white)
                                        .clipShape(Circle())
                                    })
                                }
                            }
                            .padding(.horizontal, 12)
                            
                        } else {
                            // 일시정지 버튼
                            Button(action: pasueButtonTapped, label: {
                                VStack {
                                    Image(systemName: "pause.fill")
                                        .foregroundStyle(.gray1)
                                        .font(.system(size: 55))
                                        .padding(27)
                                }
                                .background(.white)
                                .clipShape(Circle())
                            })
                        }
                    }
                    .padding(.horizontal, Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
                    .padding(.bottom, UIApplication.shared.statusBarFrame.size.height + 20)
                }
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .preventGesture()
    }
    
    func pasueButtonTapped() {
        withAnimation {
            isPause = true
        }
        mapViewModel.stopTracking()
    }
    
    func playButtonTapped() {
        withAnimation {
            isPause = false
            isShowingMessage = false
        }
        mapViewModel.startTracking()
    }
    
    func stopButtonTapped() {
        isShowingMessage = true
        
    }
    
    func stopButtonLongPressed(value: Bool) {
        mapViewModel.stopTracking()
        HapticManager.instance.impact(style: .heavy)
        router.push(.runningResult)
    }
}

//#Preview {
//    RunningLiveView()
//}
