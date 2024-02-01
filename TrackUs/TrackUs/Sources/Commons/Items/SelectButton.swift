//
//  SelectButton.swift
//  TrackUs
//
//  Created by 최주원 on 1/30/24.
//

import SwiftUI

struct SelectButton: View {
    private var selected: Bool
    private let image: [Image]?
    private let text: String
    private let widthSize: CGFloat
    private let action: () -> Void
    
    // MARK: - SelectButton(기본)
    // 사용 예시
    //enum selects{
    //    case none
    //    case one
    //    case two
    //    case three
    //}
    //@State private var selected: selects = .none
    //SelectButton(text: "첫번째", selected: selected == .one, widthSize: 194){
    //    selected = .one
    //}
    
    /// SelectButton(기본) - text: 문구, selected: 선택여부(Bool), widthSize: 가로 크기, action: 실행코드
    init(text: String, selected: Bool, widthSize: CGFloat = .infinity, action: @escaping () -> Void) {
        self.image = nil
        self.text = text
        self.selected = selected
        self.widthSize = widthSize
        self.action = action
    }
    
    
    // MARK: - SelectButton(이미지)
    // 사용 예시
    //enum selects{
    //    case none
    //    case one
    //    case two
    //    case three
    //}
    //@State private var selected: selects = .none
    //SelectButton(image: image,text: "첫번째", selected: selected == .one, widthSize: 194){
    //    selected = .one
    //}
    
    /// SelectButton(이미지) - image: 삽입 이미지, text: 문구, selected: 선택여부(Bool), widthSize: 가로 크기, action: 실행코드
    init(image: [Image]? = nil, text: String, selected: Bool, widthSize: CGFloat = .infinity, action: @escaping () -> Void) {
        self.image = image
        self.text = text
        self.selected = selected
        self.widthSize = widthSize
        self.action = action
    }
    
    
    var body: some View {
        
        Button(action: {
            action()
        }, label: {
            HStack(spacing: 20){
                if let image = image {
                    image[selected ? 0 : 1]
                        .resizable()
                        .frame(width: 20.0, height: 20.0)
                }
                Text(text)
                    .customFontStyle(selected ? .main_B16 : .gray2_L16)
            }
        })
        .frame(maxWidth: widthSize, maxHeight: 36)
        //.frame(width: widthSize, height: 36)
        .overlay(
            Capsule()
                .stroke(selected ? .main : .gray2, lineWidth: 1 )
        )
    }
}

//#Preview {
//    SelectButton(text: <#T##String#>, action: <#T##() -> Void#>)
//}


