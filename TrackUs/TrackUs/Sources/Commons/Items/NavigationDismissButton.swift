//
//  NavigationDismissButton.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import SwiftUI

struct NavigationDismissButton: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        Button(action: {
            router.popToRoot()
        }) {
            Image(systemName: "xmark")
                .foregroundStyle(.gray1)
        }
    }
}

#Preview {
    NavigationDismissButton()
}
