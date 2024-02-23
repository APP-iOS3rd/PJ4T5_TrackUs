//
//  LoadingModifier.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/21.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    let networkStatus: NetworkStatus
    func body(content: Content) -> some View {
        switch networkStatus {
        case .none:
            content
        case .loading:
            content
                .overlay (DataLoadingView())
        case .error:
            content
                .overlay (DataLoadingView())
        case .success:
            content
        }
    }
}
