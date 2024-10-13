//
//  ImageButton.swift
//  Moolog
//
//  Created by 아라 on 10/10/24.
//

import UIKit

final class ImageButton: UIButton {
    let title: String
    let image: UIImage?
    let titleColor: UIColor
    let backColor: UIColor
    let radius: CGFloat
    
    init(
        title: String,
        image: UIImage?,
        titleColor: UIColor,
        backColor: UIColor,
        radius: CGFloat
    ) {
        self.title = title
        self.image = image
        self.titleColor = titleColor
        self.backColor = backColor
        self.radius = radius
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init(title)
        attr.font = .button
        
        config.attributedTitle = attr
        config.image = image
        config.imagePadding = 6
        
        configuration = config
        backgroundColor = backColor
        tintColor = titleColor
        
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
