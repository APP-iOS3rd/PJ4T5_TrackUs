//

//
//  MyProfileView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI

struct MyProfileView: View {
    @EnvironmentObject var router: Router
    @State private var nickName: String = ""
    @State private var checkNickname: Bool = false
    @State private var selectedImage: Image? = nil
    
    var body: some View {
        ScrollView{
            VStack {
                ProfilePicker(image: $selectedImage)
                    .frame(width: 116, height: 116)
                    .padding()
                HStack {
                    Text("TrackUs님")
                        .customFontStyle(.gray1_SB16)
                        .padding()
                    NavigationLink(destination: ProfileEditView()) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.gray1)
                    }
                }
                .padding()
                Text("170cm · 70kg · 20대")
                    .customFontStyle(.gray2_R16)
                ListItems()
            }
            .customNavigation {
                Text("마이페이지")
                    .customFontStyle(.gray1_SB16)
            } right: {
                NavigationLink(destination: Settings()) {
                    Image(systemName: "gear")
                        .foregroundColor(Color.gray1)
                }
            }
        }
        
    }
    
    struct ListItems: View {
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.ViewLayout.VIEW_STANDARD_VERTICAL_SPACING) {
                Text("운동")
                    .customFontStyle(.gray1_SB17)
                    .padding(.leading)
                ListSettingsItem(title: "러닝기록")
                Divider()
                    .background(Color.Gray3)
                Text("서비스")
                    .customFontStyle(.gray1_SB16)
                    .padding(.leading)
                ListSettingsItem(title: "이용약관")
                ListSettingsItem(title: "오픈소스/라이센스")
                Divider()
                    .background(Color.Gray3)
                Text("고객지원")
                    .customFontStyle(.gray1_SB16)
                    .padding(.leading)
                ListSettingsItem(title: "자주묻는 질문 Q&A")
                ListSettingsItem(title: "문의하기")
                Divider()
                    .background(Color.Gray3)
                Text("트랙어스 응원하기")
                    .customFontStyle(.gray1_SB16)
                    .padding(.leading)
                ListSettingsItem(title: "프리미엄 결제하기")
            }
        }
    }
    
    struct ListSettingsItem: View {
        var title: String
        
        var body: some View {
            NavigationLink(destination: ExerciseView()) {
                HStack {
                    Text(title)
                        .customFontStyle(.gray1_R16)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray1)
                }
                .padding(.horizontal)
            }
        }
    }
}
    

#Preview {
    MyProfileView()
}
