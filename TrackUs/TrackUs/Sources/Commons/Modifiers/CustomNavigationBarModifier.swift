//
//  CustomNavigationBarModifier.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI

struct CustomNavigationBarModifier<C, L, R>: ViewModifier where C: View, L: View, R: View {
    let center: (() ->C)?
    let left: (() -> L)?
    let right: (() -> R)?
    
    init(center: (() -> C)?, left: (()-> L)? = {EmptyView()}, right: (()-> R)? = {EmptyView()}) {
        self.center = center
        self.left = left
        self.right = right
    }
    
    func body(content: Content) -> some View {
        VStack {
            ZStack {
                HStack {
                    left?()
                    Spacer()
                    right?()
                }
                .frame(height: 47)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Constants.ViewLayout.VIEW_STANDARD_HORIZONTAL_SPACING)
                
                HStack {
                    Spacer()
                    center?()
                    Spacer()
                }
            }
            
            Spacer()
            
            content
            
            Spacer()
        }
        .background(.white)
        .navigationBarHidden(true)
    }
}


