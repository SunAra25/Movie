//
//  BaseCollectionViewCell.swift
//  Moolog
//
//  Created by 아라 on 10/10/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    static var identifier: String {
        return String(
            describing: self
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() { }
    
    func setLayout() { }
}
