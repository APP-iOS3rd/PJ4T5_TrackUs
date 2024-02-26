//
//  UserList.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/25.
//

import SwiftUI

struct UserList: View {
    @EnvironmentObject var router: Router
    let users: [UserInfo]
    let ownerUid: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 2) {
                Text("\(users.count)명").customFontStyle(.main_B14)
                Text("의 TrackUS 회원이 이 러닝 모임에 참여중입니다!")
                    .customFontStyle(.gray2_R14)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    Button(action: {}, label: {
                        if let owner = users.first  {$0.uid == ownerUid} {
                            Button(action: {
                                router.push(.userProfile(owner.uid))
                            }, label: {
                                VStack {
                                    UserProfileCell(user: owner)
                                    HStack {
                                        Text(owner.username)
                                            .customFontStyle(.gray1_R12)
                                        Image(.crown)
                                    }
                                }
                            })
                        }
                        
                    })
                    ForEach(users.filter {$0.uid != ownerUid}, id: \.self.uid) { user in
                        Button(action: {
                            router.push(.userProfile(user.uid))
                        }, label: {
                            VStack {
                                UserProfileCell(user: user)
                                HStack {
                                    Text(user.username)
                                        .customFontStyle(.gray1_R12)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
}


//#Preview {
//    UserList()
//}
