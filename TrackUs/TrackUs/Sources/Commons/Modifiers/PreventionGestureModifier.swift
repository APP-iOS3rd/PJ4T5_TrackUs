//
//  PreventionGestureModifier.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/07.
//

import Foundation
import SwiftUI

struct PreventionGestureModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { _ in
                    }
            )
    }
}
