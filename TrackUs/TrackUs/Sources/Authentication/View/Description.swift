//
//  Description.swift
//  TrackUs
//
//  Created by 최주원 on 1/31/24.
//

import SwiftUI

struct Description: View {
    private let title: String
    private let detail: String
    
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(title)
                .customFontStyle(.gray1_B24)
            Text(detail)
                .customFontStyle(.gray2_L16)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
