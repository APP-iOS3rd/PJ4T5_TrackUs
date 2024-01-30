//
//  View+NavigationBar.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI

extension View {
    func customNavigation<C, L, R> (
        center: @escaping (() -> C),
        left: @escaping (() -> L),
        right: @escaping (() -> R)
    ) -> some View where C: View, L: View, R: View {
        modifier(CustomNavigationBarModifier(center: center, left: left, right: right))
    }
}
