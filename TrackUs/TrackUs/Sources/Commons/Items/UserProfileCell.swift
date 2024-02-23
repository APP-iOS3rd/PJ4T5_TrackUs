//
//  UserProfileCell.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI
import Kingfisher

struct UserProfileCell: View {
    var body: some View {
        KFImage(URL(string: ""))
            .onFailureImage(KFCrossPlatformImage(named: "ProfileDefault"))
            .placeholder({ProgressView()})
            .resizable()
            .scaledToFill()
            .frame(width: 61, height: 61)
            .clipShape(Circle())
    }
}

#Preview {
    UserProfileCell()
}
