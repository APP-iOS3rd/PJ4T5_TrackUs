//
//  NickNameTextFiled.swift
//  TrackUs
//
//  Created by 최주원 on 1/30/24.
//

import SwiftUI

struct NickNameTextFiled: View {
    @Binding private var text : String
    @Binding private var availability : Bool
    
    @State private var isFocused = false
    @State private var isError : Bool = false
    
    private let textLiimit = 10
    private let placeholder : String = "닉네임을 입력해주세요"
    
    
    // MARK: - 닉네임 TextFiled
    // 사용 예시
    // @State private var nickName: String
    // @State private var checkNickname: Bool
    //
    // NickNameTextFiled(text: $nickName, availability: $checkNickname)
    
    /// 닉네임 TextFiled - text: $닉네입 저장 변수(String), availability: $닉네임 기입 여부(Bool)
    init(text: Binding<String>, availability: Binding<Bool>) {
        self._text = text
        self._availability = availability
    }
    
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                TextField(placeholder, text: $text, prompt: Text(placeholder).foregroundColor(.gray))
                    .textInputAutocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .submitLabel(.continue)
                    .onTapGesture {
                        withAnimation {
                            isFocused = true
                            if isError == true {
                                isError = false
                            }
                        }
                    }
                    .onChange(of: text) { newText in
                        checkText(newText)
                        checkAvailability()
                    }
                
                // 키보드가 활성화 되어있는지 확인
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                        
                        withAnimation {
                            isFocused = false
                        }
                    }
                
                // 텍스트 클리어 버튼
                if !text.isEmpty {
                    HStack{
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.gray2)
                        }
                        Text("\(text.count)/10")
                            .frame(width: 30)
                            .customFontStyle(text.count > 10 ? .caution_L12 : .gray2_L12)
                            .animation(.easeInOut(duration: 0.15), value: text.count>10)
                    }
                }
            }
            .padding(EdgeInsets(top: 14, leading: 10, bottom: 14, trailing: 10))
            .background(Capsule()
                .foregroundStyle(isError ? .caution : (isFocused ? .main : .gray2))
                .animation(.easeInOut(duration: 0.15), value: isFocused)
                .frame(height: 1), alignment: .bottom
            )
        }
        HStack{
            Text("∙ 특수문자, 공백 제외 2~10자리")
                .customFontStyle(isError ? .caution_L12 : .gray2_L12)
            Spacer()
            if isError{
                Text("닉네임을 다시 확인해주세요.")
                    .customFontStyle(.caution_L12)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isError)
    }
    
    // 2~10글자, 공백, 특수문자 유무 확인
    private func checkText(_ newText: String) {
        let specialCharacters = CharacterSet(charactersIn: "!?@#$%^&*()_+=-<>,.;|/:[]{}")
        
        if newText.count > textLiimit || newText.count < 2 || newText.contains(" ") || newText.rangeOfCharacter(from: specialCharacters) != nil {
            return isError = true
        }else {
            return isError = false
            
        }
    }
    
    // 버튼 활성화 여부
    private func checkAvailability() {
        if !text.isEmpty && !isError{
            availability = true
        }else{
            availability = false
        }
    }
    
}

struct CheckString: View {
    @Binding var condition: Bool
    let checkString: String
    var body: some View {
        HStack{
            Image(systemName: !condition ? "checkmark" : "xmark")
                .frame(width: 15)
                .foregroundStyle(!condition ? .green : .caution)
            Text(checkString)
                .foregroundStyle(!condition ? .white : .gray)
                .font(Font.system(size: 15, weight: .regular))
        }
        .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 0))
    }
}

//#Preview {
//    NickNameTextFiled()
//}
