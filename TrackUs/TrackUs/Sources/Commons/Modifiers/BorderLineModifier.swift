//
//  BorderLineModifier.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/14.
//

import SwiftUI

struct BorderLineModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray3, lineWidth: 1)
            )
    }
}
