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
                MenuItems(sectionTitle: "운동") {
                    NavigationLink(value: "RunningRecordView") {
                        MenuItem(title: "러닝기록", image: .init(.chevronRight))
                    }
                }
                
                Divider()
                    .background(.divider)
                
                MenuItems(sectionTitle: "서비스") {
                    NavigationLink(value: "TermsOfService") {
                        MenuItem(title: "이용약관", image: .init(.chevronRight))
                    }
                    
                    NavigationLink(value: "OpenSourceLicense") {
                        MenuItem(title: "오픈소스/라이센스", image: .init(.chevronRight))
                    }
                    
                }
                
                Divider()
                    .background(.divider)
                
                MenuItems(sectionTitle: "고객지원") {
                    NavigationLink(value: "FAQView") {
                        MenuItem(title: "자주묻는 질문 Q&A", image: .init(.chevronRight))
                    }
                    NavigationLink(value: "ServiceRequest") {
                        MenuItem(title: "문의하기", image: .init(.chevronRight))
                    }
                    
                }
                
                Divider()
                    .background(.divider)
                
                MenuItems(sectionTitle: "트랙어스 응원하기 ") {
                    NavigationLink(value: "PremiumPaymentView") {
                        MenuItem(title: "프리미엄 결제하기", image: .init(.chevronRight))
                    }
                }
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
        .navigationDestination(for: String.self) { screenName in
            switch screenName {
            case "ProfileEditView":
                ProfileEditView()
            case "SettingsView":
                SettingsView()
            case "RunningRecordView":
                RunningRecordView()
            case "TermsOfService":
                WebView(url: Constants.WebViewUrl.TERMS_OF_SERVICE_URL)
                    .edgesIgnoringSafeArea(.all)
                    .customNavigation {
                        NavigationText(title: "서비스 이용약관")
                    } left: {
                        NavigationBackButton()
                    }
            case "PremiumPaymentView":
                PremiumPaymentView()
            case "FAQView":
                FAQView()
            case "WithdrawalView":
                Withdrawal()
            case "TeamIntroView":
                TeamIntroView()
            case "OpenSourceLicense":
                WebView(url: Constants.WebViewUrl.OPEN_SOURCE_LICENSE_URL )
                    .edgesIgnoringSafeArea(.all)
                    .customNavigation {
                        NavigationText(title: "오픈소스/라이센스")
                    } left: {
                        NavigationBackButton()
                    }
                
            case "ServiceRequest":
                WebView(url: Constants.WebViewUrl.SERVICE_REQUEST_URL )
                    .edgesIgnoringSafeArea(.bottom)
                    .customNavigation {
                        NavigationText(title: "문의하기")
                    } left: {
                        NavigationBackButton()
                    }
                
            default:
                EmptyView()
            }
        }
    }
}




#Preview {
    MyProfileView()
}
