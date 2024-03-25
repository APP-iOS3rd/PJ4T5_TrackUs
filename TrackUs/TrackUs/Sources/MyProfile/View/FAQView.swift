//
//  FAQView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/31.
//

import SwiftUI

struct ListGroup {
    var label: String
    var content: String
}

struct FAQView: View {
    let faqLists: [ListGroup] = [
        
        ListGroup(label: "회원 탈퇴 후 재가입이 가능한가요?", content: "네, 회원 탈퇴 후에도 다시 가입하실 수 있습니다. 다만, 탈퇴 시 기존에 등록한 모든 정보는 영구적으로 삭제되며, 회원 탈퇴 이전의 활동 내역은 복구할 수 없습니다. 또한, 동일한 이메일 주소나 닉네임으로 3회 이상 신고된 계정으로는 재가입이 제한될 수 있습니다. \n\n재가입 전에 신중히 고려해주세요. 필요한 경우, 운영팀에 문의하여 더 자세한 안내를 받을 수 있습니다."),
        ListGroup(label: "불쾌한 유저 신고는 어디에서 해야하나요?", content: "불쾌한 유저를 신고하려면 다음 단계를 따라주세요.\n1. 해당 유저의 프로필 페이지로 이동합니다.\n2. 프로필 페이지에서 빨간색 '신고하기' 버튼을 찾아 클릭합니다.\n3. 나타나는 신고 양식을 작성하여 불쾌한 행동을 설명하고 제출합니다.\n\n신고가 접수되면 운영팀에서 조치를 취할 것입니다. 사용자의 안전과 편안한 환경을 위해 신중하게 조치될 것임을 알려드립니다."),
        ListGroup(label: "개선사항은 어디에 제안할 수 있나요?", content: "서비스 이용 중 개선사항이 있으신 경우, 다음 단계를 따라 주세요.\n1. 화면 우측 상단의 프로필 아이콘을 클릭하여 프로필 페이지로 이동합니다.\n2. 프로필 페이지에서 '문의하기' 옵션을 찾아 클릭합니다.\n3. 나타나는 양식에 궁금한 점이나 제안할 사항을 자세히 기입한 후 제출합니다. \n\n제안이나 문의사항은 운영팀이 확인한 뒤 최대한 신속하게 답변해드릴 것입니다. 감사합니다.")
    ]
    
    @State private var selectedIndex: Int = -1
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(faqLists.indices, id: \.self) { index in
                    Accordian(faq: faqLists[index],  index: index, selectedIndex: $selectedIndex)
                }
            }
            Spacer()
        }
        .customNavigation {
            Text("자주묻는 질문 Q&A")
                .customFontStyle(.gray1_SB16)
        } left: {
            NavigationBackButton()
        }
    }
}

struct Accordian: View {
    let faq: ListGroup
    let index: Int
    @Binding var selectedIndex: Int
    
    var isExpanded: Bool {
        selectedIndex == index
    }
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    if isExpanded {
                        selectedIndex = -1
                    } else {
                        selectedIndex = index
                    }
                    
                }
            } label: {
                HStack {
                    Text("Q. \(faq.label)").customFontStyle(.gray1_R16)
                    Spacer()
                    Image("ChevronRight")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.horizontal, Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
            }
            .padding(.vertical, 20)
            Divider()
                .background(.divider)
            if selectedIndex == index {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Q. \(faq.label)")
                        .customFontStyle(.main_B16)
                    
                    Text(faq.content)
                        .customFontStyle(.gray1_R12)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
                Divider()
                    .background(.divider)
            }
         
        }
    }
}



#Preview {
    FAQView()
}
