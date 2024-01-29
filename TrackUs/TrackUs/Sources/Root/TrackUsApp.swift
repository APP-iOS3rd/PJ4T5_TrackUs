//
//  TrackUsApp.swift
//  TrackUs
//
//  Created by 박소희 on 1/29/24.
//

import SwiftUI

@main
struct TrackUsApp: App {
    var body: some Scene {
        @StateObject var router = Router()
        
        WindowGroup {
            ContentView()
                .environmentObject(router)
        }
    }
}
