//
//  BaseView.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/11/24.
//

import UIKit

class BaseView: UIView {
    init() {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() { }
}
