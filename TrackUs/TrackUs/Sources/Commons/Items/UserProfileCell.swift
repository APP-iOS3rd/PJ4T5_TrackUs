//
//  UserProfileCell.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI
import Kingfisher

struct UserProfileCell: View {
    let user: UserInfo
    var body: some View {
        VStack {
            KFImage(URL(string: user.profileImageUrl ?? ""))
                .onFailureImage(KFCrossPlatformImage(named: "ProfileDefault"))
                .placeholder({ProgressView()})
                .resizable()
                .scaledToFill()
                .frame(width: 61, height: 61)
                .clipShape(Circle())
        }
    }
}

//#Preview {
//    UserProfileCell()
//}
