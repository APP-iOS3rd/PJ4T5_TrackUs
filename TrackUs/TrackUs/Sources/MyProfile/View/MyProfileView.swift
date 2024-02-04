//

//
//  MyProfileView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI

struct MyProfileView: View {
    @State private var selectedImage: Image?
    @State private var isShownFullScreenCover: Bool = false
    
    var body: some View {
        VStack {
            ScrollView{
                // MARK: - 프로필 헤더
                VStack {
                    Image(.profileDefault)
                        .resizable()
                        .frame(width: 116, height: 116)
                        .padding(.vertical, 12)
                        .clipShape(Circle())
                    
                    NavigationLink(value: "ProfileEditView") {
                        HStack(spacing: 6) {
                            Text("TrackUs님")
                                .customFontStyle(.gray1_SB16)
                            
                            Image(.chevronRight)
                        }
                    }
                    
                    HStack {
                        Text("170cm · 70kg · 20대")
                            .customFontStyle(.gray2_R16)
                    }
                }
                .padding(.bottom, 32)
                
                // MARK: - 리스트
                MenuItems {
                    Text("운동")
                        .customFontStyle(.gray1_SB16)
                } content: {
                    NavigationLink(value: "RunningRecordView") {
                        MenuItem(title: "러닝기록", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                
                MenuItems {
                    Text("서비스")
                        .customFontStyle(.gray1_SB16)
                } content: {
                    NavigationLink(value: "TermsOfService") {
                        MenuItem(title: "이용약관", image: .init(.chevronRight))
                    }
                    
                    NavigationLink(value: "OpenSourceLicense") {
                        MenuItem(title: "오픈소스/라이센스", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                
                MenuItems {
                    Text("고객지원")
                        .customFontStyle(.gray1_SB16)
                } content: {
                    NavigationLink(value: "FAQView") {
                        MenuItem(title: "자주묻는 질문 Q&A", image: .init(.chevronRight))
                    }
                    NavigationLink(value: "ServiceRequest") {
                        MenuItem(title: "문의하기", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                
                MenuItems {
                    HStack(spacing: 6) {
                        Text("트랙어스 응원하기")
                            .customFontStyle(.gray1_SB16)
                        Image(.star)
                    }
                } content: {
                    Button {
                        isShownFullScreenCover.toggle()
                    } label: {
                        MenuItem(title: "프리미엄 결제하기", image: .init(.chevronRight))
                    }
                    .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                        PremiumPaymentView(isShownFullScreenCover: $isShownFullScreenCover)
                    })
                }
                .padding(.bottom, 60)
            }
        }
        .customNavigation {
            NavigationText(title: "마이페이지")
        } right: {
            NavigationLink(value: "SettingsView") {
                Image(.settingLogo)
                    .foregroundColor(Color.gray1)
            }
        }
        
    }
}




#Preview {
    MyProfileView()
}
