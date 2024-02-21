////
////  UserExample.swift
////  TrackUs
////
////  Created by 윤준성 on 2/19/24.
////
//
//import SwiftUI
//
//struct UserExample: View {
//    @EnvironmentObject var router: Router
//    @StateObject var userProfileViewModel = UserProfileViewModel.shared
//    @State private var selectedUserId: String?
//
//    var body: some View {
//        VStack {
//            // 예시 uid 설정
//            let exampleUserId = "rr1Ov2bjbGNgjFbJXfer8n3loiz2"
//            
//            Button(action: {
//                selectedUserId = exampleUserId
//                userProfileViewModel.getOtherUserInfo(for: exampleUserId) // 다른 사용자 정보 가져오기
//                router.push(.userProfile(exampleUserId)) // 프로필 페이지로 이동
//            }) {
//                Text("View Other User Profile")
//            }
//        }
//    }
//}
//
//#Preview {
//    UserExample()
//}
