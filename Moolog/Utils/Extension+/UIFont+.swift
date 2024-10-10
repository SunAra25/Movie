//
//  UIFont+.swift
//  Moolog
//
//  Created by 아라 on 10/10/24.
//

import UIKit

extension UIFont {
    public enum FontType: String {
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
    /// bold 20
    static let head = UIFont.pretendard(
        type: .bold,
        size: 20
    )
    /// bold 14
    static let sub = UIFont.pretendard(
        type: .bold,
        size: 14
    )
    /// bold 16
    static let title = UIFont.pretendard(
        type: .bold,
        size: 16
    )
    /// medium 16
    static let body1 = UIFont.pretendard(
        type: .medium,
        size: 16
    )
    /// medium 13
    static let body2 = UIFont.pretendard(
        type: .medium,
        size: 13
    )
    /// medium 12
    static let caption = UIFont.pretendard(
        type: .medium,
        size: 12
    )
    /// bold 15
    static let button = UIFont.pretendard(
        type: .bold,
        size: 15
    )
}
