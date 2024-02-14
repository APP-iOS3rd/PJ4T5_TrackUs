//
//  UINavigationController+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/02.
//

import SwiftUI

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    // 뒤로가기 스와이프 제스처 가능하도록 수정
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
