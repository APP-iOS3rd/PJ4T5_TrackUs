//
//  CompletButton.swift
//  TrackUs
//
//  Created by 최주원 on 1/30/24.
//

import SwiftUI

struct MainButton: View {
    private var active: Bool
    private var minHeight: CGFloat = 56
    private let text: String
    private let cornerRadius: CGFloat = 14
    private let buttonColor: Color
    private let action: () -> Void
    
    
    // MARK: - 기본 버튼
    // 사용 예시
    // MainButton(buttonText: "버튼 문구") { 실행코드 추가 }
    
    /// 기본 버튼 -> text: 버튼 표시 내용, action:  버튼 클릭 시 실행 코드
    init(buttonText: String, action: @escaping () -> Void) {
        self.active = true
        self.text = buttonText
        self.action = action
        self.buttonColor = .main
    }
    
    // MARK: - 활성화 버튼
    // 사용 예시
    // CompletButton(active: Bool, buttonText: "버튼 문구") { 실행코드 추가 }
    
    /// 활성화 버튼 -> active: true = 활성화, false = 비활성화
    init(active: Bool, buttonText: String, buttonColor: Color = .main, minHeight: CGFloat = 56, action: @escaping () -> Void) {
        self.active = active
        self.text = buttonText
        self.action = action
        self.buttonColor = buttonColor
        self.minHeight = minHeight
    }
    
    var body: some View {
        Button(action: action) {
            HStack (spacing: 0) {
                Text(text)
                    .customFontStyle(active ? .white_B16 : .gray1_B16)
                    .frame(maxWidth: .infinity, minHeight: minHeight)
            }
            .background(active ? buttonColor : .gray3)
            .clipShape(Capsule())
        }
        .animation(.easeInOut(duration: 0.1), value: active)
        .disabled(!active)
    }
}

#Preview {
    MainButton(buttonText: "테스트") {
    }
}
