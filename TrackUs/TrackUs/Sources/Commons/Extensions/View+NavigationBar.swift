//
//  View+NavigationBar.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI

extension View {
    
    /// 커스텀 네비게이션 View extension 메서드 입니다.
    /// - Parameters:
    ///   - center: View(필수)
    ///   - left: View
    ///   - right: View
    /// - Returns: View
    func customNavigation<C, L, R> (
        center: @escaping (() -> C),
        left: @escaping (() -> L),
        right: @escaping (() -> R)
    ) -> some View where C: View, L: View, R: View {
        modifier(CustomNavigationBarModifier(center: center, left: left, right: right))
    }
    
    /// 커스텀 네비게이션 View extension 메서드 입니다.
    /// - Parameters:
    ///   - center: View(필수)
    ///   - right: View
    /// - Returns: View
    func customNavigation<C, R> (
        center: @escaping (() -> C),
        right: @escaping (() -> R)
    ) -> some View where C: View, R: View {
        modifier(CustomNavigationBarModifier(center: center, right: right))
    }
    
    /// 커스텀 네비게이션 View extension 메서드 입니다.
    /// - Parameters:
    ///   - center: View(필수)
    ///   - left: View
    /// - Returns: View
    func customNavigation<C, L> (
        center: @escaping (() -> C),
        left: @escaping (() -> L)
    ) -> some View where C: View, L: View {
        modifier(CustomNavigationBarModifier(center: center, left: left))
    }
    
    /// 커스텀 네비게이션 View extension 메서드 입니다.
    /// - Parameters:
    ///   - center: View(필수)
    /// - Returns: View
    func customNavigation<C> (
        center: @escaping (() -> C)
    ) -> some View where C: View {
        modifier(CustomNavigationBarModifier(center: center))
    }
    
}
