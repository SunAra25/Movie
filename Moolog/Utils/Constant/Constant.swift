//
//  Constant.swift
//  Moolog
//
//  Created by 아라 on 10/10/24.
//

import UIKit

enum Constant {
    case screenWidth
    case horiSpacing
    case vertiSpacing
    
    var value: CGFloat {
        switch self {
        case .screenWidth:
            return UIScreen.main.bounds.width
        case .horiSpacing:
            return CGFloat(16)
        case .vertiSpacing:
            return CGFloat(12)
        }
    }
}
