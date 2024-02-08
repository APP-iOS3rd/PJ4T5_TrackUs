//
//  View+Gesture.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/07.
//

import SwiftUI

extension View {
    func preventGesture() -> some View {
        modifier(PreventionGestureModifier())
    }
}
