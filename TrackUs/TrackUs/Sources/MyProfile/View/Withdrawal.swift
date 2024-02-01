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
    @EnvironmentObject var router: Router
    @State private var text: String = ""
    @State private var isAgreed: Bool = false
    @State private var showWithdrawalAlert: Bool = false
    @State private var isEditing: Bool = true

    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: Constants.ViewLayout.VIEW_STANDARD_VERTICAL_SPACING) {
                Text("회원탈퇴 안내")
                    .customFontStyle(.gray1_SB16)
                Text("회원 탈퇴시 아래 사항을 꼭 확인해 주세요.")
                    .customFontStyle(.gray1_R12)
                VStack(alignment: .leading, spacing: Constants.ViewLayout.VIEW_STANDARD_VERTICAL_SPACING) {
                    Text("1.개인 정보 및 이용 기록은 모두 삭제되며, 삭제된 계정은 복구할 수 없습니다.")
                        .customFontStyle(.gray2_R16)
                    Text("2.프리미엄 결제 기록의 남은 기간 금액은 환불되지 않습니다.")
                        .customFontStyle(.gray2_R16)
                    Text("3.러닝 데이터를 포함한 모든 운동에 관련된 정보는 따로 저장되지 않으며 즉시 삭제 됩니다.")
                        .customFontStyle(.gray2_R16)
                }
                Spacer()
                Text("회원탈퇴 사유")
                    .customFontStyle(.gray1_SB16)
                ZStack(alignment: .topLeading) {
                    PlaceholderTextView(text: $text, placeholder: "탈퇴 사유를 적어주세요.", font: UIFont.systemFont(ofSize: 16), textColor: UIColor.gray)
                        .frame(height: 200)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.gray3, lineWidth: 1)
                        )
                        .onTapGesture {
                            isEditing = true
                        }
                }

                HStack {
                    Text("안내 사항 확인 후 탈퇴에 동의합니다.")
                        .customFontStyle(.gray1_R16)
                    Spacer()
                    Image(systemName: isAgreed ? "largecircle.fill.circle" : "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            isAgreed.toggle()
                        }
                }
                MainButton(active: true, buttonText: "회원탈퇴") {
                    showWithdrawalAlert = true
                }
                .padding(.horizontal)
                .alert(isPresented: $showWithdrawalAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text("정말 탈퇴를 진행하시겠습니까?\n트랙어스 서비스의 모든 데이터가 삭제됩니다."),
                        primaryButton: .cancel(),
                        secondaryButton: .destructive(Text("ok"), action: {
                            // 회원 탈퇴 동작 추가
                        })
                    )
                }
            }
            .padding(.horizontal)
            .padding()
            Spacer()
        }
        .customNavigation {
            Text("회원탈퇴")
                .customFontStyle(.gray1_SB16)
        } left: {
            NavigationBackButton()
        }
    }
}

#Preview {
    Withdrawal()
}
