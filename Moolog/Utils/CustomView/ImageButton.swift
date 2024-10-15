//
//  ImageButton.swift
//  Moolog
//
//  Created by 아라 on 10/10/24.
//

import UIKit

final class ImageButton: UIButton {
    let title: String?
    let image: UIImage?
    let foreColor: UIColor
    let backColor: UIColor?
    let radius: CGFloat?
    
    init(
        title: String? = nil,
        image: UIImage?,
        foreColor: UIColor,
        backColor: UIColor? = nil,
        radius: CGFloat? = nil
    ) {
        self.title = title
        self.image = image
        self.foreColor = foreColor
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
        if let title {
            var attr = AttributedString.init(title)
            attr.font = .button
            config.attributedTitle = attr
        }
        
        config.image = image
        config.imagePadding = 6
        
        configuration = config
        backgroundColor = backColor
        tintColor = foreColor
        
        if let radius {
            layer.cornerRadius = radius
            layer.masksToBounds = true
        }
    }
}
