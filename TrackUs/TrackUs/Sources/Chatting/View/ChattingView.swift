//
//  UserExample.swift
//  TrackUs
//
//  Created by 윤준성 on 2/19/24.
//

import SwiftUI

struct ChattingView: View {
    @EnvironmentObject var router: Router
    @StateObject var userProfileViewModel = UserProfileViewModel.shared
    @State private var selectedUserId: String?

    var body: some View {
        VStack {
            // 예시 uid 설정
            let exampleUserId = "fjYp9S7WlqcZRSeKchdWvSFJMTk2"
            
            Button(action: {
                selectedUserId = exampleUserId
                userProfileViewModel.getOtherUserInfo(for: exampleUserId)
                router.push(.userProfile(exampleUserId))
            }) {
                Text("View Other User Profile")
            }
        }
    }
}

#Preview {
    ChattingView()
}
