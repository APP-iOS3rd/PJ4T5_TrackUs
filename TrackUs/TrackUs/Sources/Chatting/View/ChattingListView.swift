//
//  ChattingListView.swift
//  TrackUs
//
//  Created by 최주원 on 2/16/24.
//

import SwiftUI

struct ChattingListView: View {
    @EnvironmentObject var router: Router
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @StateObject var chatViewModel = ChatListViewModel()
    
    //@State private var chatRooms: [ChatRoom] = []
    // 테스트용 채팅방
    //let chatRoom1 = ChatRoom(id: "chat_id1", title: "Chat Room1 Title", members: [""])
    // 테스트 값 나중 대체
    private var numberChatroom = 5
    
    var body: some View {
        List{
            ForEach(chatViewModel.chatRooms, id: \.id) { chatRoom in
                HStack{
                    // 채팅방 이미지
                    Image(.profileDefault)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    // 채팅 제목, 최근 메세지
                    VStack(alignment: .leading){
                        // 채팅 제목
                        HStack{
                            // 1:1 채팅 제목 받아오기 추가
                            if chatRoom.gruop {
                                Text(chatRoom.title)
                                    .customFontStyle(.gray1_B16)
                            }else {
//                                Text(chatRoom.members)
//                                .customFontStyle(.gray1_B16)
                            }
                            // 채팅방 인원수
                            Image(systemName: "person.fill")
                            Text("\(chatRoom.members.count)")
                        }
                        // 최신 메세지
                        Text(chatRoom.latestMessage?.text ?? "")
                    }
                    Spacer()
                    
                    VStack{
                        // 최신 메세지 시간
                        Text("마지막 날짜")
                        // 신규 메세지 갯수
                        Text("메세지 갯수")
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            // 채팅방 목록 리스너 등록
            chatViewModel.subscribeToUpdates()
        }
//        .onReceive(DataVieModle.$conversations) { conversation in
//            // ViewModel에서 받아온 채팅방 리스트 업데이트
//            self.conversations = conversation
//        }
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
