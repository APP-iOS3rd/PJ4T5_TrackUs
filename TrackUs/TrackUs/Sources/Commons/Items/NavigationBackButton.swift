//
//  NavigationBackButton.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI

struct NavigationBackButton: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        Button(action: {
            router.pop()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.gray1)
        }
    }
}

#Preview {
    NavigationBackButton()
}
