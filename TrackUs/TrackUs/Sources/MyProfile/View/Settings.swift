//
//  Settings.swift
//  TrackUs
//
//  Created by 박소희 on 1/31/24.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        ScrollView{
            ListItems()
                .customNavigation {
                    Text("설정")
                        .customFontStyle(.gray1_SB16)
                } left: {
                    NavigationBackButton()
                }
            
        }
    }
    
    struct ListItems: View {
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.ViewLayout.VIEW_STANDARD_VERTICAL_SPACING) {
                Text("앱 정보")
                    .customFontStyle(.gray1_SB17)
                    .padding(.leading)
                HStack{
                    Text("버전정보")
                        .customFontStyle(.gray1_R16)
                        .padding(.leading)
                    Spacer()
                    Text("v.1.0.0")
                        .customFontStyle(.gray1_R16)
                        .padding(.trailing)
                }
                ListSettingsItem(title: "팀 트랙어스")
                Divider()
                    .background(Color.Gray3)
                Text("계정관련")
                    .customFontStyle(.gray1_SB17)
                    .padding(.leading)
                Text("로그아웃")
                    .customFontStyle(.gray1_R16)
                    .padding(.leading)
                NavigationLink(destination: Withdrawal()) {
                    Text("회원탈퇴")
                        .customFontStyle(.caution_R17)
                        .padding(.leading)
                }
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
    Settings()
}

