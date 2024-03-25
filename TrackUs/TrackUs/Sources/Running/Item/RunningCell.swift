//
//  RunningCell.swift
//  TrackUs
//
//  Created by 권석기 on 3/19/24.
//

import SwiftUI

import SwiftUI
import Kingfisher

struct RunningCell: View {
    let course: Course
    let user: UserInfo
    
    var body: some View {
        VStack(spacing: 0) {
            KFImage(URL(string: course.routeImageUrl))
                .placeholder({ProgressView()})
                .onFailureImage(KFCrossPlatformImage(named: "ProfileDefault"))
                .resizable()
                .frame(height: 140)
                .cornerRadius(12, corners: [.topLeft, .topRight])
                
            VStack(alignment: .leading, spacing: 6) {
                RunningStyleBadge(style: .init(rawValue: course.runningStyle) ?? .walking)
                
                Text(course.title)
                    .customFontStyle(.gray1_B16)
                
                VStack(alignment: .leading, spacing: 2) {
                    Label(course.address, image: "Pin")
                        .customFontStyle(.gray2_L12)
                    
                    Label(course.startDate?.formattedString() ?? Date().formatted(), systemImage: "calendar")
                        .customFontStyle(.gray2_L12)
                    
                    HStack {
                        Label(course.distance.asString(unit: .kilometer), image: "arrowBoth")
                            .customFontStyle(.gray2_L12)
                        Spacer()
                        Label("\(course.members.count)/\(course.numberOfPeople)", systemImage: "person.2.fill")
                            .customFontStyle(.gray2_L12)
                    }
                    
                    HStack(spacing: 0) {
                        KFImage(URL(string: user.profileImageUrl ?? ""))
                            .placeholder({ProgressView()})
                            .onFailureImage(KFCrossPlatformImage(named: "ProfileDefault"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                        
                        Text(user.username)
                            .customFontStyle(.gray2_L12)
                            .padding(.leading, 4)
                        Image(.crown)
                            .padding(.leading, 2)
                    }
                }
            }
            .padding(12)
            .background(.white)
            .clipped()
            .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
            .shadow(color: .divider, radius: 3, x: 0, y: 0)
        }
        .frame(width: 176)
    }
}
