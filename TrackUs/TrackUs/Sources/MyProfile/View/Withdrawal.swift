//
//  Withdrawal.swift
//  TrackUs
//
//  Created by 박소희 on 1/31/24.
//

import SwiftUI
import UIKit

struct PlaceholderTextView: UIViewRepresentable {
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: PlaceholderTextView
        
        init(_ parent: PlaceholderTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.placeholder {
                textView.text = ""
                textView.textColor = parent.textColor
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor.gray
            }
        }
    }
    
    @Binding var text: String
    var placeholder: String
    var font: UIFont
    var textColor: UIColor
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = font
        textView.textColor = UIColor.gray
        textView.text = placeholder
        textView.backgroundColor = UIColor.clear
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if !text.isEmpty {
            uiView.text = text
        } else {
            uiView.text = placeholder
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

struct Withdrawal: View {
    @StateObject var authViewModel = AuthenticationViewModel.shared
    @EnvironmentObject var router: Router
    @State private var reason: String = ""
    @State private var isAgreed: Bool = false
    @State private var showWithdrawalAlert: Bool = false
    @State private var isEditing: Bool = true
    
    // 회원 탈퇴
    private func deleteAccount() {
        Task {
            if await authViewModel.deleteAccount(withReason: reason) == true {
                router.popToRoot()
            }
        }
    }
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                // MARK: - 회원탈퇴 안내 텍스트
                VStack(alignment: .leading) {
                    Text("회원탈퇴 안내")
                        .customFontStyle(.gray1_SB16)
                        .multilineTextAlignment(.leading)
                    
                    Text("회원 탈퇴시 아래 사항을 꼭 확인해 주세요.")
                        .font(.system(size: 14))
                        .foregroundStyle(.caution)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. 개인 정보 및 이용 기록은 모두 삭제되며, 삭제된 계정은 복구할 수 없습니다.")
                            .customFontStyle(.gray2_R16)
                        
                        Text("2. 프리미엄 결제 기록의 남은 기간 금액은 환불되지 않습니다.")
                            .customFontStyle(.gray2_R16)
                        
                        Text("3. 러닝 데이터를 포함한 모든 운동에 관련된 정보는 따로 저장되지 않으며 즉시 삭제 됩니다.")
                            .customFontStyle(.gray2_R16)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                
                
                // MARK: - 회원탈퇴 사유 입력
                VStack(alignment: .leading) {
                    Text("회원탈퇴 사유")
                        .customFontStyle(.gray1_SB16)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 12)
                    
                    ZStack(alignment: .topLeading) {
                        PlaceholderTextView(text: $reason, placeholder: "탈퇴 사유를 작성해주세요.", font: UIFont.systemFont(ofSize: 14), textColor: UIColor.gray)
                            .frame(height: 290)
                            .padding(.horizontal)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray3, lineWidth: 1)
                            )
                            .onTapGesture {
                                isEditing = true
                            }
                    }
                }
                .padding(.top, 66)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // 탈퇴 동의
                HStack {
                    Text("안내 사항 확인 후 탈퇴에 동의합니다.")
                        .customFontStyle(.gray1_R16)
                    Spacer()
                    Circle()
                        .strokeBorder(.gray1, lineWidth: 1)
                        .frame(width: 18, height: 18)
                        .overlay (
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(isAgreed ? .main : .white)
                        )
                    
                        .onTapGesture {
                            isAgreed.toggle()
                        }
                }
                .padding(.vertical, 20)
                
            }
            MainButton(active: isAgreed, buttonText: "회원탈퇴", action: withdrawalButtonTapped)
        }
        .padding(.horizontal, Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
        .customNavigation {
            Text("회원탈퇴")
                .customFontStyle(.gray1_SB16)
        } left: {
            NavigationBackButton()
        }
    }
    
    func withdrawalButtonTapped() {
        Task {
            let isDeleted = await authViewModel.deleteAccount(withReason: reason)
            if isDeleted {
                router.popToRoot()
                router.push(.running)
            }
        }
    }
}

#Preview {
    Withdrawal()
}
