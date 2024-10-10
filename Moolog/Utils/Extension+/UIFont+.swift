//
//  UIFont+.swift
//  Moolog
//
//  Created by 아라 on 10/10/24.
//

import UIKit

extension UIFont {
    public enum FontType: String{
        case bold = "Bold"
        case medium = "Medium"
    }
    
    static func pretendard(
        type: FontType,
        size: CGFloat
    ) -> UIFont? {
        return .init(
            name: "Pretendard-\(type.rawValue)",
            size: size
        )
    }
}

extension UIFont {
    static let head = UIFont.pretendard(
        type: .bold,
        size: 20
    )
    
    static let sub = UIFont.pretendard(
        type: .bold,
        size: 14
    )
    
    static let title = UIFont.pretendard(
        type: .bold,
        size: 16
    )
    
    static let body1 = UIFont.pretendard(
        type: .medium,
        size: 16
    )
    
    static let body2 = UIFont.pretendard(
        type: .medium,
        size: 13
    )
    
    static let caption = UIFont.pretendard(
        type: .medium,
        size: 12
    )
    
    static let button = UIFont.pretendard(
        type: .bold,
        size: 15
    )
}
