//
//  Router.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI

final class Router: ObservableObject {
    public enum Destination: Hashable {
        static func == (lhs: Destination, rhs: Destination) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        case running
        case report
        case myProfile
        
        var id: String {
            String(describing: self)
        }
    }

    @Published var path = NavigationPath()
    
    func push(to destination: Destination) {
        path.append(destination)
    }
    
    func pop() {
        if path.count != 0 {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
}
