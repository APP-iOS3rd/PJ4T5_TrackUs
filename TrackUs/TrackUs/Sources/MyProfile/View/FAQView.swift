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
        ListGroup(label: "결제 취소는 어디에서 해야하나요?", content: "감사위원은 원장의 제청으로 대통령이 임명하고, 그 임기는 4년으로 하며, 1차에 한하여 중임할 수 있다. 대통령이 제1항의 기간내에 공포나 재의의 요구를 하지 아니한 때에도 그 법률안은 법률로서 확정된다. 대통령이 궐위되거나 사고로 인하여 직무를 수행할 수 없을 때에는 국무총리, 법률이 정한 국무위원의 순서로 그 권한을 대행한다. 국가는 전통문화의 계승·발전과 민족문화의 창달에 노력하여야 한다. 대통령의 임기가 만료되는 때에는 임기만료 70일 내지 40일전에 후임자를 선거한다. 국무총리는 대통령을 보좌하며, 행정에 관하여 대통령의 명을 받아 행정각부를 통할한다. 대법원과 각급법원의 조직은 법률로 정한다. 의무교육은 무상으로 한다. 대법원장과 대법관이 아닌 법관은 대법관회의의 동의를 얻어 대법원장이 임명한다. 이 헌법에 의한 최초의 대통령의 임기는 이 헌법시행일로부터 개시한다. 누구든지 병역의무의 이행으로 인하여 불이익한 처우를 받지 아니한다. 군인은 현역을 면한 후가 아니면 국무위원으로 임명될 수 없다."),
        ListGroup(label: "불쾌한 유저 신고는 어디에서 해야하나요?", content: "국가는 국민 모두의 생산 및 생활의 기반이 되는 국토의 효율적이고 균형있는 이용·개발과 보전을 위하여 법률이 정하는 바에 의하여 그에 관한 필요한 제한과 의무를 과할 수 있다. 국가는 농업 및 어업을 보호·육성하기 위하여 농·어촌종합개발과 그 지원등 필요한 계획을 수립·시행하여야 한다. 선거에 관한 경비는 법률이 정하는 경우를 제외하고는 정당 또는 후보자에게 부담시킬 수 없다. 국회의원은 국가이익을 우선하여 양심에 따라 직무를 행한다. 사회적 특수계급의 제도는 인정되지 아니하며, 어떠한 형태로도 이를 창설할 수 없다. 교육의 자주성·전문성·정치적 중립성 및 대학의 자율성은 법률이 정하는 바에 의하여 보장된다."),
        ListGroup(label: "애플 워치와도 연동이 되나요?", content: "국민경제자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다. 국가는 건전한 소비행위를 계도하고 생산품의 품질향상을 촉구하기 위한 소비자보호운동을 법률이 정하는 바에 의하여 보장한다. 법관이 중대한 심신상의 장해로 직무를 수행할 수 없을 때에는 법률이 정하는 바에 의하여 퇴직하게 할 수 있다. 중앙선거관리위원회는 법령의 범위안에서 선거관리·국민투표관리 또는 정당사무에 관한 규칙을 제정할 수 있으며, 법률에 저촉되지 아니하는 범위안에서 내부규율에 관한 규칙을 제정할 수 있다.")
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
