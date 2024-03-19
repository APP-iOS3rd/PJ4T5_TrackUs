//
//  LoadingModifier.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/21.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    let loadingStatus: Bool
    func body(content: Content) -> some View {
        switch loadingStatus {
        case true:
            content
                .overlay (CircleLoadingView())
        case false:
            content
                
        }
    }
}
