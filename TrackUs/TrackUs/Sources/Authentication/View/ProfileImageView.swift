//
//  ProfileImageView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

struct ProfileImageView: View {
    @Binding private var signUpFlow: SignUpFlow
    @State private var image: Image?
    @State private var availability: Bool = false
    
    init(signUpFlow: Binding<SignUpFlow>) {
        self._signUpFlow = signUpFlow
    }
    
    var body: some View {
        VStack{
            Description(title: "프로필 사진 등록", detail: "다른 러너들에게 자신을 잘 나타낼 수 있는 프로필 이미지를 설정해주세요.")
            
            ProfilePicker(image: $image)
                .offset(y: 40)
            
            Spacer()
            
            MainButton(active: image != nil, buttonText: "다음으로") {
                signUpFlow = .physical
            }
        }
        
    }
}
