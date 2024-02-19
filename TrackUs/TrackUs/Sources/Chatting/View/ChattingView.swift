//
//  ChattingView.swift
//  TrackUs
//
//  Created by 윤준성 on 2/1/24.
//

import SwiftUI

// 임시
struct ChatMessage: Identifiable {
    let id = UUID()
    let isCurrentUser: Bool // 현재 사용자가 작성한 메시지 여부
    let message: String // 메시지 내용
    let time: String // 메시지 작성 시간
}

struct ChattingView: View {
    @StateObject var authViewModel = AuthenticationViewModel.shared
    
    @State private var sideMenuPresented: Bool = false
    @State private var sendMessage: String = ""
    
    @State private var sideMenuTranslation: CGFloat = 0
    private let chatTitle: String
    
    @State var previousUser: Bool = false
    
    
    var messages = [
            ChatMessage(isCurrentUser: true, message: "안녕하세요.", time: "10:00 AM"),
            ChatMessage(isCurrentUser: false, message: "안녕하세요!", time: "10:01 AM"),
            ChatMessage(isCurrentUser: true, message: "만나서 반가워요!", time: "10:02 AM"),
            ChatMessage(isCurrentUser: false, message: "저도 반가워요!", time: "10:03 AM"),
            ChatMessage(isCurrentUser: true, message: "안녕하세요.", time: "10:04 AM"),
            ChatMessage(isCurrentUser: false, message: "안녕하세요!", time: "10:04 AM"),
            ChatMessage(isCurrentUser: true, message: "만나서 반가워요!", time: "10:05 AM"),
            ChatMessage(isCurrentUser: true, message: "dkddkkkkwlnqlnrl아ㅏ아아!", time: "10:05 AM"),
            ChatMessage(isCurrentUser: false, message: "저도 반가워요!", time: "10:06 AM"),
            ChatMessage(isCurrentUser: false, message: "저도 반가워요!", time: "10:06 AM"),
            ChatMessage(isCurrentUser: true, message: "안녕하세요.", time: "10:07 AM"),
            ChatMessage(isCurrentUser: false, message: "안녕하세요!", time: "10:10 AM"),
            ChatMessage(isCurrentUser: true, message: "만나서 반가워요!", time: "10:12 AM"),
            ChatMessage(isCurrentUser: false, message: "저도 반가워요!", time: "10:13 AM")
        ]
    
    init(chatTitle: String) {
        self.chatTitle = chatTitle
    }
    
    var body: some View {
        ZStack(alignment: .trailing){
            VStack(alignment: .leading){
                // 채팅 내용 표기
                ScrollView{
                    VStack(spacing: 6) {
                        ForEach(messages.indices, id: \.self) { index in
                            let showProfileInfo = index == 0 || messages[index].isCurrentUser != messages[index - 1].isCurrentUser
                            ChatMessageView(message: messages[index], previousUser: showProfileInfo).id(index)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                Spacer()
                messageBar
                    .padding(.horizontal, 16)
            }
            .customNavigation {
                Text(chatTitle)
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
            SideMenuView()
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
        .animation(.easeInOut, value: sideMenuPresented)
//        .safeAreaInset(edge: .trailing) {
//            if sideMenuPresented {
//                            SideMenuView()
//                                .frame(maxWidth: .infinity, alignment: .trailing)
//                                .transition(.move(edge: .trailing))
//                                .animation(.default, value: sideMenuPresented)
//                        }
//        }
        

    }
    var messageBar: some View {
        // 하단 메세지 보내기
        HStack(alignment: .bottom, spacing: 12){
            ZStack{
                TextField("대화를 입력해주세요.", text: $sendMessage, axis: .vertical)
                //TextEditor(text: $sendMessage)
                    .customFontStyle(.gray1_R14)
                    .lineLimit(1...5)
                    .padding(10)
            }
            
            // 사진 촬영 업로드 버튼
            Button(
                action: {
                    
                }, label: {
                    Image(systemName: "camera")
                        .resizable()
                        .foregroundStyle(.gray1)
                        .frame(width: 20, height: 18)
                        .padding(.vertical, 9)
                })
            
            // 사진 업로드 버튼
            Button(
                action: {
                    
                }, label: {
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundStyle(.gray1)
                        .frame(width: 18, height: 18)
                        .padding(.vertical, 9)
                })
            // 메세지 전송 버튼
            Button(
                action: {
                    
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
}

struct ChatMessageView: View {
    let message: ChatMessage
    var previousUser: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            if !message.isCurrentUser && previousUser {
                Image(.profileDefault) // 사용자 프로필 이미지
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }else{
                Spacer(minLength: 47)
            }
            
            VStack(alignment: .leading) {
                if !message.isCurrentUser && previousUser {
                    Text("상대방 이름") // 상대방 이름
                        .customFontStyle(.gray1_R12)
                }
                HStack(alignment: .bottom){
                    if message.isCurrentUser {
                        Spacer()
                        Text(message.time) // 메시지 작성 시간
                            .customFontStyle(.gray1_R12)
                    }
                    Text(message.message) // 메시지 내용
                        .customFontStyle(message.isCurrentUser ? .white_M14 : .gray1_R14)
                        .padding(8)
                        .background(message.isCurrentUser ? .main : .gray3)
                        .cornerRadius(10)
                    if !message.isCurrentUser {
                        Text(message.time) // 메시지 작성 시간
                            .customFontStyle(.gray1_R12)
                        Spacer()
                    }
                }
                
            }
            
            
        }
    }
}

struct SideMenuView: View {
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                // 제목부분
                VStack(alignment: .leading, spacing: 6){
                    Text("러닝메이트 채팅방")
                        .customFontStyle(.gray1_B16)
                    HStack{
                        Image(systemName: "person.fill")
                            .resizable()
                            .foregroundStyle(.gray1)
                            .frame(width: 12, height: 12)
                        // 인원수
                        Text("5")
                            .customFontStyle(.gray1_R12)
                    }
                }
                .padding(16)
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundStyle(.gray3)
                VStack(alignment: .leading, spacing: 6){
                    Text("채팅밤 맴버")
                        .customFontStyle(.gray1_R12)
                    // 참여 중인 사용자 프로필 정보
                    HStack{
                        //ForEach
                        Image(.profileDefault)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        Text("닉네임")
                            .customFontStyle(.gray1_M16)
                    }
                    
                }
                .padding(16)
                Spacer()
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundStyle(.gray3)
                Button(action: {
                    // 나가기 기능
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


#Preview {
    ChattingView(chatTitle: "채팅방 2")
}
