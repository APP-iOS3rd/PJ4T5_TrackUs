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
    @StateObject var chatViewModel = ChattingViewModel.shared
    
    @State private var chatRooms: [ChatRoom] = []
    // 테스트용 채팅방
    let chatRoom1 = ChatRoom(id: "chat_id1", title: "Chat Room1 Title", members: [:])
    let chatRoom2 = ChatRoom(id: "chat_id2", title: "Chat Room2 Title", members: [:])
    let chatRoom3 = ChatRoom(id: "chat_id3", title: "Chat Room3 Title", members: [:])
    // 테스트 값 나중 대체
    private var numberChatroom = 5
    
    var body: some View {
        List{
            Button(action: {
                router.push(.chatting)
            }, label: {
                Text("메세지창 확인")
            })
                Button(action: {
                    chatViewModel.createChatRoom(chatRoom: chatRoom1)
                }, label: {
                    Text("채팅방1 생성")
                })
                Button(action: {
                    chatViewModel.createChatRoom(chatRoom: chatRoom2)
                }, label: {
                    Text("채팅방2 생성")
                })
                Button(action: {
                    chatViewModel.createChatRoom(chatRoom: chatRoom3)
                }, label: {
                    Text("채팅방3 생성")
                })
                Button(action: {
                    chatViewModel.joinChatRoom(chatRoomID: "chat_id1", userUID: authViewModel.userInfo.uid)
                }, label: {
                    Text("채팅방1 참여")
                })
                Button(action: {
                    chatViewModel.joinChatRoom(chatRoomID: "chat_id2", userUID: authViewModel.userInfo.uid)
                }, label: {
                    Text("채팅방2 참여")
                })
                Button(action: {
                    chatViewModel.joinChatRoom(chatRoomID: "chat_id3", userUID: authViewModel.userInfo.uid)
                }, label: {
                    Text("채팅방3 참여")
                })
                Button(action: {
                    chatViewModel.leaveChatRoom(chatRoomID: "chat_id1", userUID: authViewModel.userInfo.uid)
                }, label: {
                    Text("채팅방1 나가기")
                })
                Button(action: {
                    chatViewModel.leaveChatRoom(chatRoomID: "chat_id2", userUID: authViewModel.userInfo.uid)
                }, label: {
                    Text("채팅방2 나가기")
                })
                Button(action: {
                    chatViewModel.leaveChatRoom(chatRoomID: "chat_id3", userUID: authViewModel.userInfo.uid)
                }, label: {
                    Text("채팅방3 나가기")
                })
            Text("==== 아래 출력 ====")
            // List {
            ForEach(chatRooms, id: \.id) { chatRoom in
                
                Button(action: {
                    router.push(.chatting)
                    chatViewModel.currentChatRoom = chatRoom
                }, label: {
                    HStack {
                        Image(.profileDefault)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            HStack{
                                Text(chatRoom.title)
                                    .customFontStyle(.gray1_B16)
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .foregroundStyle(.gray1)
                                    .frame(width: 12, height: 12)
                                // 인원수 수정
                                Text("5")
                                    .customFontStyle(.gray1_R12)
                            }
                            Text("최근 메세지 출력")
                                .customFontStyle(.gray2_R14)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text("시간")
                                .customFontStyle(.gray2_R12)
                            Text("채팅수?")
                                .customFontStyle(.gray2_R12)
                        }
                    }
                    
                })
            }
            //}
            
            Text("==== 위 출력 ====")
        }
        .listStyle(PlainListStyle())
//        .onAppear {
//            // ViewModel에서 채팅방 리스트 받아오기
//            chatViewModel.fetchChatRooms(forUserUID: authViewModel.userInfo.uid)
//            print("채팅 목록",chatViewModel.chatRooms)
//            self.chatRooms = chatViewModel.chatRooms
//            print("채팅 목록2",chatRooms)
//        }
        .onReceive(chatViewModel.$chatRooms) { chatRooms in
            // ViewModel에서 받아온 채팅방 리스트 업데이트
            self.chatRooms = chatRooms
        }
//            ForEach(0..<numberChatroom, id: \.self) { num in
//                HStack{
//                    // 이미지 논의 후 수정
//                    Image(.profileDefault)
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                        .clipShape(Circle())
//                    
//                    VStack(alignment: .leading) {
//                        Text("채팅방 제목")
//                            .customFontStyle(.gray1_B16)
//                        Text("가장 최신 메세지")
//                            .customFontStyle(.gray2_R14)
//                    }
//                    
//                    Spacer()
//                    HStack{
//                        Text("시간")
//                            .customFontStyle(.gray2_R12)
//                        Text("채팅수?")
//                            .customFontStyle(.gray2_R12)
//                    }
//                }
//            }
        
    }
}

#Preview {
    ChattingListView()
}
