//
//  ChattingListView.swift
//  TrackUs
//
//  Created by 최주원 on 2/16/24.
//

import SwiftUI
import Kingfisher

struct ChattingListView: View {
    @EnvironmentObject var router: Router
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @StateObject var chatViewModel = ChatListViewModel()
    
    // 테스트 값 나중 대체
    private var numberChatroom = 5
    
    var body: some View {
        ZStack{
            if chatViewModel.chatRooms.count == 0{
                Text("참여한 채팅방이 없습니다")
                    .font(.title)
                    .foregroundStyle(.gray3)
            }
            
            List{
                ForEach(chatViewModel.chatRooms, id: \.id) { chatRoom in
                    Button {
                        router.push(.chatting(ChatViewModel(chatRoom: chatRoom, users: chatViewModel.users)))
                    } label: {
                        HStack(spacing: 12){
                            // 채팅방 이미지
                            ChatRoomImage(members: chatRoom.nonSelfMembers, users: chatViewModel.users)
                                .frame(width: 52, height: 52)
                            // 채팅 제목, 최근 메세지
                            VStack(alignment: .leading, spacing: 4){
                                // 채팅 제목
                                HStack(spacing: 4){
                                    // 1:1 채팅 제목 받아오기 추가
                                    if chatRoom.group {
                                        Text(chatRoom.title)
                                            .customFontStyle(.gray1_B16)
                                    }else {
                                        Text(chatViewModel.users[chatRoom.nonSelfMembers.first ?? ""]?.userName ?? "TrackUs")
                                            .customFontStyle(.gray1_B16)
                                    }
                                    // 채팅방 인원수
                                    if chatRoom.group {
                                        Image(systemName: "person.2.fill")
                                            .customFontStyle(.gray2_L12)
                                        Text("\(chatRoom.members.count)")
                                            .customFontStyle(.gray2_L12)
                                    }
                                }
                                // 최신 메세지
                                Text(chatRoom.latestMessage?.text ?? "작성된 메세지가 없습니다.")
                                    .customFontStyle(.gray2_R12)
                                    .lineLimit(2)
                            }
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 0){
                                // 최신 메세지 시간
                                Text(chatRoom.latestMessage?.timestamp?.timeAgoFormat() ?? "")
                                    .customFontStyle(.gray1_R12)
                                Spacer()
                                // 신규 메세지 갯수
                                usersUnreadCoun(count: chatRoom.usersUnreadCountInfo[authViewModel.userInfo.uid])
                            }
                            .frame(height: 40)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .customNavigation(center: {
            Text("채팅 목록")
                .customFontStyle(.gray1_B16)
        })
        .onAppear {
            // 채팅방 목록 리스너 등록
            chatViewModel.subscribeToUpdates()
        }
    }
}

/// 채팅방 프로필사진 목록
struct ChatRoomImage: View {
    let members: [String]
    let users: [String: Member]
    
    var body: some View {
        switch members.count {
        case 1:
            ProfileImage(ImageUrl: users[members[0]]?.profileImageUrl, size: 50)
        case 2:
            ZStack {
                ProfileImage(ImageUrl: users[members[0]]?.profileImageUrl, size: 30)
                    .offset(x: -11, y: 11)
                ProfileImage(ImageUrl: users[members[1]]?.profileImageUrl, size: 30)
                    .offset(x: 11, y: 11)
            }
        case 3:
            VStack(spacing: 1) {
                HStack(spacing: 1) {
                    ForEach(members.prefix(2), id: \.self) { member in
                        ProfileImage(ImageUrl: users[member]?.profileImageUrl, size: 25)
                    }
                }
                ProfileImage(ImageUrl: users[members[2]]?.profileImageUrl, size: 25)
            }
        default:
            VStack(spacing: 1) {
                HStack(spacing: 1) {
                    ForEach(members.prefix(2), id: \.self) { member in
                        ProfileImage(ImageUrl: users[member]?.profileImageUrl, size: 25)
                    }
                }
                HStack(spacing: 1) {
                    ForEach(members.suffix(2), id: \.self) { member in
                        ProfileImage(ImageUrl: users[member]?.profileImageUrl, size: 25)
                    }
                }
            }
        }
    }
}

/// KFImage - Url 있으면 해당사진, 없으면 profileDefault 사진
struct ProfileImage: View {
    let ImageUrl: String?
    let size: CGFloat
    
    var body: some View {
        if let profileImageUrl = ImageUrl{
            KFImage(URL(string: profileImageUrl))
                .resizable()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }else {
            Image(.profileDefault)
                .resizable()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}

struct usersUnreadCoun: View {
    let count: Int?
    
    var body: some View {
        if let count = count{
            if count != 0 && count <= 300 {
                //Text("\(count)")
                Text("N")
                    .foregroundStyle(.white)
                    .font(.system(size: 12, weight: .bold))
                    .padding(.vertical, 3)
                    .padding(.horizontal, 6)
                    .frame(minWidth: 18)
                    .background(
                        Capsule()
                            .foregroundStyle(.caution)
                    )
            }else if  count > 300 {
                //Text("300+")
                Text("N")
                    .foregroundStyle(.white)
                    .font(.system(size: 12, weight: .bold))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(
                        Capsule()
                            .foregroundStyle(.caution)
                    )
            }
        }
    }
}

#Preview {
    ChattingListView()
}

extension Date {
    func timeAgoFormat(numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let date = self
        let now = Date()
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if components.year! >= 2 {
            return "\(components.year!)년 전"
        } else if components.year! >= 1 {
            if numericDates {
                return "1년 전"
            } else {
                return "작년"
            }
        } else if components.month! >= 2 {
            return "\(components.month!)달 전"
        } else if components.month! >= 1 {
            if numericDates {
                return "1달 전"
            } else {
                return "지난달"
            }
        } else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!)주 전"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1주 전"
            } else {
                return "지난주"
            }
        } else if components.day! >= 2 {
            return "\(components.day!)일 전"
        } else if components.day! >= 1 {
            if numericDates {
                return "1일 전"
            } else {
                return "어제"
            }
        } else if components.hour! >= 2 {
            return "\(components.hour!)시간 전"
        } else if components.hour! >= 1 {
            if numericDates {
                return "1시간 전"
            } else {
                return "1시간 전"
            }
        } else if components.minute! >= 2 {
            return "\(components.minute!)분 전"
        } else if components.minute! >= 1 {
            if numericDates {
                return "1분 전"
            } else {
                return "조금 전"
            }
        } else {
            return "지금"
        }
    }
}
