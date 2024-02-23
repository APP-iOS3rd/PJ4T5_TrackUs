//
//  RoundedTextEditor.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import SwiftUI

struct RoundedTextEditor: View {
    @Binding var text: String
    
    var body: some View {
           VStack {
               // 2.
               TextEditor(text: $text)
                   .customFontStyle(.gray2_R16)
                   .padding()
                   .lineSpacing(5) //줄 간격
                   .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                   .cornerRadius(8)
                   .overlay(
                       RoundedRectangle(cornerRadius: 8)
                           .stroke(.gray3, lineWidth: 1)
                   )
               Spacer()
           }
       }
}

#Preview {
    RoundedTextEditor(text: .constant("some text"))
}
