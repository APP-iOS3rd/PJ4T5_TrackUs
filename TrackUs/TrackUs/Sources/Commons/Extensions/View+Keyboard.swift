//
//  View+Keyboard.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/01.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
