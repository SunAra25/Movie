//
//  CreditCollectionViewCell.swift
//  Moolog
//
//  Created by 아라 on 10/13/24.
//

import UIKit

import SnapKit

final class CreditCollectionViewCell: BaseCollectionViewCell {
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .body2
        label.textColor = .baseBG
        return label
    }()
    
    override func setUI() {
        [
            imageView,
            nameLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.size.equalTo(56)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview().inset(4)
        }
    }
}
