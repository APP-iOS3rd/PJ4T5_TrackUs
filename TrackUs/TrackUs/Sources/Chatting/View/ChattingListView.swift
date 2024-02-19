//
//  ChattingListView.swift
//  TrackUs
//
//  Created by 최주원 on 2/16/24.
//

import SwiftUI

struct ChattingListView: View {
    @EnvironmentObject var router: Router
    
    // 테스트 값 나중 대체
    private var numberChatroom = 5
    
    var body: some View {
        ScrollView {
            Button(action: {
                router.push(.chatting(uid: "테스트"))
            }, label: {
                Text("테스트 버튼")
            })
            ForEach(0..<numberChatroom, id: \.self) { num in
                HStack{
                    // 이미지 논의 후 수정
                    Image(.profileDefault)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text("채팅방 제목")
                            .customFontStyle(.gray1_B16)
                        Text("가장 최신 메세지")
                            .customFontStyle(.gray2_R14)
                    }
                    
                    Spacer()
                    HStack{
                        Text("시간")
                            .customFontStyle(.gray2_R12)
                        Text("채팅수?")
                            .customFontStyle(.gray2_R12)
                    }
                }
            }
        }
    }
}

#Preview {
    ChattingListView()
}
