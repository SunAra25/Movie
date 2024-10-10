//
//  BaseTableViewCell.swift
//  Moolog
//
//  Created by 아라 on 10/10/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    static var identifier: String {
        return String(
            describing: self
        )
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }
    
    func setLayout() { }
}
