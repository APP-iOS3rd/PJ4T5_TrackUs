//
//  PremiumPaymentView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

struct PremiumPaymentView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        //        PreparingService()
        VStack {
            Image(.iconTrackUsPro2)
                .resizable()
                .frame(width: 100, height: 58)
                .padding()
            
            VStack(alignment: .leading) {
                HStack {
                    Image(.trashSlash) // crown
                    
                    Text("TrackUs Pro 구독 혜택")
                        .customFontStyle(.gray1_B16) // 575757 B 16
                    
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.main)
                    Text("구독 혜택1")
                        .customFontStyle(.gray1_M16)
                }
                .padding(.vertical, 12)
                
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.main)
                    Text("구독 혜택1")
                        .customFontStyle(.gray1_M16)
                }
                .padding(.vertical, 12)
                
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.main)
                    Text("구독 혜택1")
                        .customFontStyle(.gray1_M16)
                }
                .padding(.vertical, 12)
                
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.main)
                    Text("구독 혜택1")
                        .customFontStyle(.gray1_M16)
                }
                .padding(.vertical, 12)
                
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.main)
                    Text("구독 혜택1")
                        .customFontStyle(.gray1_M16)
                }
                .padding(.vertical, 12)
            }
//            .padding(.horizontal, 6)
            
            Spacer()
            
            Text("트랙어스 프리미엄 구독 서비스는 트랙어스 팀에게 큰 힘이 됩니다. 또, 그만한 가치의 보상을 제공받을 수 있으며 앞으로 점차 많은 혜택을 준비하도록 약속하겠습니다. 참고로 환불은 불가능합니다.")
                .customFontStyle(.gray1_R12)
                .multilineTextAlignment(.center)
            
            VStack {
                
                Button {
                    
                } label: {
                    Text("TrackUs Pro 월 결제 : 14,900/월")
                        .customFontStyle(.gray1_SB17)
                }
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .modifier(BorderLineModifier())
                .padding(.vertical, 20)
                
                
                Button {
                    
                } label: {
                    Text("TrackUs Pro 연 결제 : 149,900/연") //424242 SM17?
                        .customFontStyle(.gray1_SB17)
                }
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .modifier(BorderLineModifier())
            }
        }
        .padding(.horizontal, 29)
        .padding(.bottom, 34)
        .customNavigation {
            NavigationText(title: "Pro 구독하기")
        } left: {
            Button(action: {
                router.dismissFullScreenCover()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray1)
            })
        }
    }
}

#Preview {
    PremiumPaymentView()
}
