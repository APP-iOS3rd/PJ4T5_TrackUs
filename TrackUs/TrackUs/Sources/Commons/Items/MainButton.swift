//
//  CompletButton.swift
//  TrackUs
//
//  Created by 최주원 on 1/30/24.
//

import SwiftUI

struct MainButton: View {
    var active: Bool
    let text: String
    let cornerRadius: CGFloat = 14
    
    // 활성화 버튼 색상 지정 후 설정
    private let activeBackground: Color = .MainColor
    private let activeFontColor: Color = .white
    
    // 비활성화 버튼 색상 지정 후 설정
    private let deactiveBackground: Color = .MainColor
    private let deactiveFontColor: Color = .gray
    let action: () -> Void
    
    
    // MARK: - 기본 버튼
    // 사용 예시
    // MainButton(buttonText: "버튼 문구") { 실행코드 추가 }
    
    /// 기본 버튼 -> text: 버튼 표시 내용, action:  버튼 클릭 시 실행 코드
    init(buttonText: String, action: @escaping () -> Void) {
        self.active = true
        self.text = buttonText
        self.action = action
    } 
    
    // MARK: - 활성화 버튼
    // 사용 예시
    // CompletButton(active: Bool, buttonText: "버튼 문구") { 실행코드 추가 }
    
    /// 활성화 버튼 -> active: true = 활성화, false = 비활성화
    init(active: Bool, buttonText: String, action: @escaping () -> Void) {
        self.active = active
        self.text = buttonText
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack (spacing: 0) {
                    Text(text)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 56)
            }
            .foregroundColor(active ? activeFontColor : deactiveFontColor)
            .background(active ? activeBackground : deactiveBackground)
            .clipShape(Capsule())
        }
        .animation(.easeInOut(duration: 0.1), value: active)
        .disabled(!active)
//        .frame(maxWidth: .infinity)
//        .frame(height: 56)
    }
}

#Preview {
    MainButton(buttonText: "테스트") {
    }
}
