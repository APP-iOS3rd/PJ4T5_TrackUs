//
//  ContentView.swift
//  TrackUs
//
//  Created by 박소희 on 1/29/24.
//

import SwiftUI

struct ContentView: View {
    let isMainView = true
    var body: some View {
        if isMainView {
//            MainTabView()
            LoginView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
