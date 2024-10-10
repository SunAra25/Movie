//
//  Constant.swift
//  Moolog
//
//  Created by 아라 on 10/10/24.
//

import UIKit

enum Constant {
    enum Numeric {
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
    
    enum NavigationTitle: String {
        case searchTitle = "내가 찜한 리스트"
    }
    
    enum SectionHeader: String {
        case rising = "지금 뜨는 영화"
        case recommend = "추천 시리즈 & 영화"
        case similar = "비슷한 콘텐츠"
    }
    
    enum ContentType: String {
        case movie = "영화"
        case series = "시리즈"
    }
    
    enum ButtonType: String {
        case play = "재생"
        case favorite = "내가 찜한 리스트"
        case save = "저장"
        case check = "확인"
    }
    
    enum AlertTitle: String {
        case already = "이미 저장된 미디어예요 :)"
        case saved = "미디어를 저장했어요 :)"
    }
}
