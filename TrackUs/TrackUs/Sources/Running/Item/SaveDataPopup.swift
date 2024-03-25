//
//  SaveDataPopup.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/21.
//

import SwiftUI

struct SaveDataPopup: View {
    @Binding var showingPopup: Bool
    @Binding var title: String
    @EnvironmentObject var router: Router
    @FocusState private var titleTextFieldFocused: Bool
    
    let confirmAction: () -> ()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("러닝 기록 저장")
                    .customFontStyle(.gray1_B16)
                
                Text("러닝기록 저장을 위해\n러닝의 이름을 설정해주세요.")
                    .customFontStyle(.gray1_R14)
                    .padding(.top, 8)
                
                VStack {
                    TextField("저장할 러닝 이름을 입력해주세요.", text: $title)
                        .customFontStyle(.gray1_R12)
                        .padding(8)
                        .frame(height: 32)
                        .textFieldStyle(PlainTextFieldStyle())
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(titleTextFieldFocused ? .main : .gray2))
                        .focused($titleTextFieldFocused)
                }
                .padding(.top, 16)
                
                HStack {
                    Button(action: {
                        showingPopup = false
                    }, label: {
                        Text("취소")
                            .customFontStyle(.main_R16)
                            .frame(minHeight: 40)
                            .padding(.horizontal, 20)
                            .overlay(Capsule().stroke(.main))
                    })
                    
                    MainButton(active: true, buttonText: "확인", minHeight: 40) {
                        confirmAction()
                    }
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        
        .frame(width: 290, alignment: .leading)
        .background(.white)
        .cornerRadius(12)
    }
}
