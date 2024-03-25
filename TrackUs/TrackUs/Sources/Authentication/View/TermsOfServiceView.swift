//
//  TermsOfServiceView.swift
//  TrackUs
//
//  Created by 최주원 on 3/18/24.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Binding private var signUpFlow: SignUpFlow
    
    // 전체 선택
    private var isAllSelected: Bool {
        return isPrivacyPolicySelected && isUserSelected && isLocationTermsSelected && isOver14Selected
    }
    
    @State private var isPrivacyPolicySelected = false
    @State private var isUserSelected = false
    @State private var isLocationTermsSelected = false
    @State private var isOver14Selected = false
    
    init(signUpFlow: Binding<SignUpFlow>) {
        self._signUpFlow = signUpFlow
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40){
            Description(title: "이용 약관", detail: "TrackUs의 원할한 서비스 제공을 위해 이용 약관의 동의가 필요합니다.")
            
            VStack(alignment: .leading, spacing: 16){
                
                Button(action: {
                    if !isAllSelected {
                    isPrivacyPolicySelected = true
                    isUserSelected = true
                    isLocationTermsSelected = true
                    isOver14Selected = true
                } else {
                    // 선택 해제 시 모든 선택사항 초기화
                    isPrivacyPolicySelected = false
                    isUserSelected = false
                    isLocationTermsSelected = false
                    isOver14Selected = false
                }
                }, label: {
                    HStack{
                        Image(systemName: isAllSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(isAllSelected ? .main : .gray3)
                        Text("모두 동의합니다.")
                            .customFontStyle(.gray1_B16)
                        Spacer()
                        
                    }
                })
                Rectangle()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 1)
                    .foregroundStyle(.gray3)
                
                TermsButton(selected: $isOver14Selected, text: "만 14세 이상입니다")
                TermsButton(selected: $isUserSelected, text: "이용약관 동의")
                TermsButton(selected: $isPrivacyPolicySelected, text: "개인정보 처리방침 동의")
                TermsButton(selected: $isLocationTermsSelected, text: "위치정보 서비스 이용약관 동의")
            }
            Spacer()
            
            MainButton(active: isAllSelected, buttonText: "동의하고 가입하기") {
                signUpFlow = .nickname
            }
        }
    }
}

struct TermsButton: View {
    @Binding var selected: Bool
    let text: String
    
    var body: some View{
        Button(action: {
            selected.toggle()
        }, label: {
            HStack{
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(selected ? .main : .gray3)
                Text(text)
                    .customFontStyle(.gray1_R14)
                Spacer()
                
            }
        })
        
    }
//    func makeBody(configuration: Configuration) -> some View {
//        HStack {
//            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
//                .foregroundColor(configuration.isOn ? .green : .gray)
//            configuration.label
//        }
//    }
}

//#Preview {
//    TermsOfServiceView()
//}
