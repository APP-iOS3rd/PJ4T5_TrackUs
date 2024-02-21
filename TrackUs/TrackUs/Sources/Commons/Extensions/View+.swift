//
//  View+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/21.
//

import SwiftUI

extension View {
    func loadingWithNetwork(status: NetworkStatus) -> some View {
        modifier(LoadingModifier(networkStatus: status))
    }
}
