//
//  RunningSelectView.swift
//  TrackUs
//
//  Created by 박선구 on 2/23/24.
//

import SwiftUI

struct RunningSelectView: View {
    var vGridItems = [GridItem()]
    @State private var isPersonalRunning: Bool = false
    @State private var showingPopup: Bool = false
    @State var isSelect: Int?
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("러닝 시작하기")
                    .customFontStyle(.gray1_B24)
                Text("원하는 러닝 타입을 선택하신 뒤 러닝 시작 버튼을 눌러주세요")
                    .customFontStyle(.gray2_R15)
                
                Text("참여 러닝 모임 리스트")
                    .customFontStyle(.gray1_SB17)
                    .padding(.top, 37)
            }
            .padding(.horizontal, 16)
            
            ZStack {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: vGridItems, spacing: 8) {
                        ForEach(0..<5) { item in
                            Button {
                                isSelect = item == isSelect ? nil : item
                            } label: {
//                                selectedCell(isSelect: isSelect == item)
                                selectedCell(isSelect: isPersonalRunning == false ? isSelect == item : isSelect == nil)
                            }
                        }
                    }
                    
                }
                .padding(.horizontal, 16)
                
                if isPersonalRunning {
                    Color.black.opacity(0.3)
                        .blur(radius: 1)
                }
            }
            
            VStack {
                Button {
                    isPersonalRunning.toggle()
                } label: {
                    HStack(spacing: 8){
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(.main.opacity(isPersonalRunning ? 1 : 0))
                            .padding(4)
                            .overlay(
                                Circle()
                                    .stroke(.gray3, lineWidth: 1)
                            )
                        Text("개인 러닝 모드")
                            .customFontStyle(.gray1_R12)
                    }
                    .animation(.easeIn(duration: 0.3), value: isPersonalRunning)
                }
                .padding(.vertical, 8)
                
                MainButton(buttonText: "러닝 시작") {
                    if isPersonalRunning {
                        showingPopup.toggle()
                    } else {
                        // 메이트러닝시작
                        
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        
//        .padding(.horizontal, 16)
//        .padding(.vertical, 20)
        .popup(isPresented: $showingPopup) {
            SettingPopup(showingPopup: $showingPopup, settingVM: SettingPopupViewModel())
        } customize: {
            $0
                .backgroundColor(.black.opacity(0.3))
                .isOpaque(true)
                .dragToDismiss(false)
                .closeOnTap(false)
        }
        .customNavigation {
            NavigationText(title: "러닝 시작하기")
        } left: {
            NavigationBackButton()
        }
    }
}

struct selectedCell: View {
    var isSelect: Bool
    var body: some View {
        HStack(alignment: .center) {
            Image(.mapPath)
                .frame(width: 75, height: 75)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("광명시 러닝 메이트 구합니다")
                        .bold()
                        .customFontStyle(.gray1_R14)
                    
                    Spacer()
                    
//                    Text("걷기")
//                        .foregroundColor(.white)
//                        .font(.system(size: 10))
//                        .fontWeight(.semibold)
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 3)
//                        .background(Color.main)
//                        .cornerRadius(25)
//                    Text("빠른걸음")
//                        .foregroundColor(.white)
//                        .font(.system(size: 10))
//                        .fontWeight(.semibold)
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 3)
//                        .background(Color.main)
//                        .cornerRadius(25)
//                    Text("러닝")
//                        .foregroundColor(.white)
//                        .font(.system(size: 10))
//                        .fontWeight(.semibold)
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 3)
//                        .background(Color.main)
//                        .cornerRadius(25)
                    Text("스프린트")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.main)
                        .cornerRadius(25)
                }
                
                HStack {
                    HStack {
                        Image(.pin)
                        Text("서울숲카페거리")
                            .customFontStyle(.gray1_R9)
                    }
                    HStack {
                        Image(.timerLine)
                        Text("10:02AM")
                            .customFontStyle(.gray1_R9)
                    }
                    HStack {
                        Image(.arrowBoth)
                        Text("1.72km")
                            .customFontStyle(.gray1_R9)
                    }
                }
                
                HStack {
                    HStack {
                        Image(.profileDefault)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.vertical, 12)
                            .clipShape(Circle())
                        Text("TrackUs")
                            .customFontStyle(.gray2_R12)
                        Image(.crown)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                            .resizable()
                            .frame(width: 15, height: 12)
                            .foregroundColor(.gray1)
                        
                        Text("3/6")
                            .customFontStyle(.gray1_M16)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelect ? .main : .gray3, lineWidth: 4)
        )
        .cornerRadius(12)
        
    }
}

#Preview {
    RunningSelectView()
}
