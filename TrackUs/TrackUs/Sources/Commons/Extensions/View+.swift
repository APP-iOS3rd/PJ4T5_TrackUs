//
//  View+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/21.
//

import SwiftUI

extension View {
    func loadingWithNetwork(status: Bool) -> some View {
        modifier(LoadingModifier(loadingStatus: status))
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
          clipShape( RoundedCorner(radius: radius, corners: corners) )
      }
}


struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
