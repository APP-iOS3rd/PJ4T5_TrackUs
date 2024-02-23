//
//  UIImage+.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/21.
//

import UIKit

extension UIImage {
    static func imageFromView(view: UIView) -> UIImage? {
        // bitmap 이미지 컨텍스트 생성
           UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
           view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
           defer { UIGraphicsEndImageContext() }
           guard let context = UIGraphicsGetCurrentContext() else { return nil }
           view.layer.render(in: context)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           return image
       }
}
