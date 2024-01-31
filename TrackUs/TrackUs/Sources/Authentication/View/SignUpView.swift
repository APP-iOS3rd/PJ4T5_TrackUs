//
//  SignUpView.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

enum SignUpFlow {
    case nickname
    case image
    case physical
    case ageGender
    case runningStyle
    case daily
}

struct SignUpView: View {
    private var signUpFlow: SignUpFlow = .nickname
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SignUpView()
}
