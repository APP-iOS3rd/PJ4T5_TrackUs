//
//  NickNameTextFiled.swift
//  TrackUs
//
//  Created by 최주원 on 1/30/24.
//

import SwiftUI

struct NickNameTextFiled: View {
    private let textLiimit = 10
    private let placeholder : String = "닉네임을 입력해주세요"
    
    @State private var isFocused = false
    @State private var isError : Bool = false
    @Binding var text : String
    @Binding var availability : Bool
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                TextField(placeholder, text: $text, prompt: Text(placeholder).foregroundColor(.gray))
                    .textInputAutocapitalization(.none)
                    .autocorrectionDisabled(true)
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
                        print("-------- Error : \(isError) ---------")
                        print("-------- text.count : \(text.count) ---------")
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
                                .foregroundColor(.gray)
                        }
                        Text("\(text.count)/10")
                            .foregroundColor(.gray)
                            .font(Font.system(size: 12, weight: .light))
                    }
                }
            }
            .padding(EdgeInsets(top: 14, leading: 10, bottom: 14, trailing: 10))
            .background(Capsule()
                        // 회색 지정 후 수정 ‼️‼️
                .foregroundStyle(isFocused ? .main : .gray)
                .animation(.easeInOut(duration: 0.15), value: isFocused)
                .frame(height: 1), alignment: .bottom
            )
        }
        HStack{
            Text("∙ 영문 및 한글 2~10자리(특수문자, 공백 금지)")
                .font(Font.system(size: 11, weight: .regular))
                .foregroundStyle(isError ? .red : .gray)
                .animation(.easeInOut(duration: 0.15), value: isError)
            Spacer()
        }
    }
    
    private func checkText(_ newText: String) {
        let specialCharacters = CharacterSet(charactersIn: "!?@#$%^&*()_+=-<>,.;|/:[]{}")
        
        if newText.count > textLiimit || newText.contains(" ") || newText.rangeOfCharacter(from: specialCharacters) != nil {
            //text = String(text.prefix(text.count - 1))
            return isError = true
        }else {
            return isError = false
            
        }
        
        // 텍스트에 특수문자가 들어가면 안됨
//        if let _ = newText.rangeOfCharacter(from: specialCharacters) {
//            text = String(text.prefix(text.count - 1))
//            return isError = true
//        }
//        return isError = false
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
                .foregroundStyle(!condition ? .green : .red)
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
