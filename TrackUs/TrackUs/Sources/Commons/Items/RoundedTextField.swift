//
//  RoundedTextField.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import SwiftUI

struct RoundedTextField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .frame(height: 48)
            .padding(.leading, 16)
            .customFontStyle(.gray2_R16)
        
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray3, lineWidth: 1)
            )
            
    }
}

#Preview {
    RoundedTextField(text: .constant("some text"), placeholder: "some text")
}
