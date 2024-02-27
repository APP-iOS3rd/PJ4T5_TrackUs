//
//  UserExample.swift
//  TrackUs
//
//  Created by 윤준성 on 2/19/24.
//

import SwiftUI

public var previoosUser1: String?
public var previousdate1: String?

struct ChattingView: View {
    @EnvironmentObject var router: Router
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @StateObject var chatViewModel: ChatViewModel
    
    @State private var sideMenuPresented: Bool = false
    @State private var sendMessage: String = ""
    
    @State private var sideMenuTranslation: CGFloat = 0
    
    @State var previousUser: String?
    
    @State private var title: String = ""
    @State private var scrollToBottom = false // State 변수 추가
    
    private func updatePreviousSender(_ sender: String) -> Bool{
        if previousUser != sender {
            self.previousUser = sender
            return true
        }else{
            previousUser = nil
            return false
        }
    }
    
    var body: some View {
        ZStack(alignment: .trailing){
            VStack(alignment: .leading){
                // 채팅 내용 표기
                ScrollViewReader{ proxy in
                    ScrollView{
                        VStack(spacing: 6) {
                            ForEach(chatViewModel.messages, id: \.self.id) { message in
                                ChatMessageView(message: message,
                                                mymessge: message.sendMember.uid == authViewModel.userInfo.uid)
                                .id(message)
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .onChange(of: chatViewModel.messages.count) { _ in // 새 메시지가 추가될 때마다 호출
                        proxy.scrollTo(chatViewModel.messages.last?.id, anchor: .bottom)
                    }
                    .onAppear {
                        proxy.scrollTo(chatViewModel.messages.last?.id, anchor: .bottom)
                    }
                }
                Spacer()
                messageBar
                    .padding(.horizontal, 16)
            }
            .customNavigation {
                Text(title)
            } left: {
                NavigationBackButton()
            } right: {
                Button(
                    action: {
                        sideMenuPresented.toggle()
                        sideMenuTranslation = 0
                    }, label: {
                        // 이미지 추후 수정
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.gray1)
                    })
            }
            //.padding(.horizontal, 16)
            if sideMenuPresented{
                Color.gray.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        sideMenuPresented.toggle()
                    }
            }
            SideMenuView
                .frame(width: 300)
                .offset(x: sideMenuPresented ? sideMenuTranslation : 300, y: 0)
                .animation(.easeInOut, value: sideMenuPresented)
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            if value.translation.width > 0 {
                                sideMenuTranslation = value.translation.width
                            }
                        }.onEnded{ value in
                            let dragOffset = value.translation.width
                            
                            if dragOffset < 30 {
                                sideMenuTranslation = -0
                            }else {
                                sideMenuTranslation = .zero
                                sideMenuPresented.toggle()
                            }
                        }
                    )
            
            
        }
        .onAppear {
            title = chatViewModel.chatRoom.group ? chatViewModel.chatRoom.title : chatViewModel.members[chatViewModel.chatRoom.nonSelfMembers.first!]?.userName ?? "러너"
            
        }
        .animation(.easeInOut, value: sideMenuPresented)
        .onDisappear {
            // 메세지 읽음 확인
            chatViewModel.resetUnreadCounter(myuid: authViewModel.userInfo.uid)
        }
        

    }
    /// 메세지 바
    var messageBar: some View {
        // 하단 메세지 보내기
        HStack(alignment: .bottom, spacing: 12){
            ZStack{
                TextField("대화를 입력해주세요.", text: $sendMessage, axis: .vertical)
                    .customFontStyle(.gray1_R14)
                    .lineLimit(1...5)
                    .padding(10)
            }
            
            // 사진 촬영 업로드 버튼
//            Button(
//                action: {
//
//                }, label: {
//                    Image(systemName: "camera")
//                        .resizable()
//                        .foregroundStyle(.gray1)
//                        .frame(width: 20, height: 18)
//                        .padding(.vertical, 9)
//                })
//
//            // 사진 업로드 버튼
//            Button(
//                action: {
//
//                }, label: {
//                    Image(systemName: "photo")
//                        .resizable()
//                        .foregroundStyle(.gray1)
//                        .frame(width: 18, height: 18)
//                        .padding(.vertical, 9)
//                })
            // 메세지 전송 버튼
            Button(
                action: {
                    
                    
                    // 메세지 전송 함수
                    chatViewModel.sendChatMessage(chatText: sendMessage, uid: authViewModel.userInfo.uid)
                    sendMessage = ""
                }, label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .foregroundStyle(.main)
                        .frame(width: 36, height: 36)
                })
        }
        .frame(maxWidth: .infinity, minHeight: 36)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray3, lineWidth: 1)
        )
    }
    /// 사이드 메뉴
    var SideMenuView: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 제목부분
            VStack(alignment: .leading, spacing: 6){
                Text(title)
                    .customFontStyle(.gray1_B16)
                HStack{
                    Image(systemName: "person.fill")
                        .resizable()
                        .foregroundStyle(.gray1)
                        .frame(width: 12, height: 12)
                    // 인원수
                    Text("\(chatViewModel.members.count)")
                        .customFontStyle(.gray1_R12)
                }
            }
            .padding(16)
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundStyle(.gray3)
            VStack(alignment: .leading, spacing: 6){
                Text("채팅방 맴버")
                    .customFontStyle(.gray1_R12)
                // 참여 중인 사용자 프로필 정보
                ForEach(chatViewModel.chatRoom.members, id: \.self) { uid in
                    HStack{
                        ProfileImage(ImageUrl: chatViewModel.members[uid]?.profileImageUrl, size: 40)
                        Text("\(chatViewModel.members[uid]?.userName ?? "")")
                            .customFontStyle(.gray1_R14)
                    }
                }
            }
            .padding(16)
            Spacer()
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundStyle(.gray3)
            Button(action: {
                // 나가기 기능
                if chatViewModel.chatRoom.group {
                    chatViewModel.leaveChatRoom(chatRoomID: chatViewModel.chatRoom.id, userUID: authViewModel.userInfo.uid)
                }else {
                    chatViewModel.deleteChatRoom(chatRoomID: chatViewModel.chatRoom.id)
                }
                router.pop()
            }) {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .foregroundStyle(.gray1)
            }
            .padding(16)
        }
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.white)
        .transition(.move(edge: .trailing)) // 오른쪽에서 나오도록 애니메이션 적용
    }
}

struct ChatMessageView: View {
    //@Binding var previousUser: String
    
    let message: Message
    let mymessge: Bool
    @State private var previousUser: Bool = false
    @State private var previousdate: Bool = false
    
    var body: some View {
//        if previousdate {
//            Text(message.date)
//                .customFontStyle(.gray1_R12)
//        }
        HStack(alignment: .top) {
            if !mymessge && previousUser {
                ProfileImage(ImageUrl: message.sendMember.profileImageUrl, size: 40)
            }else{
                Spacer(minLength: 47)
            }
            
            VStack(alignment: .leading) {
                if !mymessge && previousUser {
                    Text(message.sendMember.userName) // 상대방 이름
                        .customFontStyle(.gray1_R12)
                }
                HStack(alignment: .bottom){
                    if mymessge {
                        Spacer()
                        Text(message.time) // 메시지 작성 시간
                            .customFontStyle(.gray1_R12)
                    }
                    Text(message.text!) // 메시지 내용
                        .customFontStyle(mymessge ? .white_M14 : .gray1_R14)
                        .padding(8)
                        .background(mymessge ? .main : .gray3)
                        .cornerRadius(10)
                    if !mymessge {
                        Text(message.time) // 메시지 작성 시간
                            .customFontStyle(.gray1_R12)
                        Spacer()
                    }
                }
                
            }
            
            
        }
        .onAppear {
            previousUser = previoosUser1 == message.sendMember.uid ? false : true
            previousdate = previousdate1 == message.date ? false : true
            previoosUser1 = message.sendMember.uid
            previousdate1 = message.date
        }
    }
}

