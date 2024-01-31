//
//  SelectButton.swift
//  TrackUs
//
//  Created by 최주원 on 1/30/24.
//

import SwiftUI

struct SelectButton: View {
    private let image: Image?
    private let text: String
    private var select: Bool = false
    private let action: () -> Void
    
    init(image: Image? = nil, text: String, select: Bool ,action: @escaping () -> Void) {
        self.text = text
        self.image = image
        self.action = action
    }
    
    
    var body: some View {
        
        Button(action: {
            
        }, label: {
            HStack(spacing: 20){
                if let image = image {
                    image
                        .resizable()
                        .frame(width: 20.0, height: 20.0)
                }
                Text(text)
                    .font(.system(size: 16, weight: .light))
            }
        })
    }
}

//#Preview {
//    SelectButton(text: <#T##String#>, action: <#T##() -> Void#>)
//}


