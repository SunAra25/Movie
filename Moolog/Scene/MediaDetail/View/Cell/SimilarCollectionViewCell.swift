//
//  SimilarCollectionViewCell.swift
//  Moolog
//
//  Created by 아라 on 10/13/24.
//

import UIKit

import SnapKit

final class SimilarCollectionViewCell: BaseCollectionViewCell {
    private let posterImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    override func setUI() {
        contentView.addSubview(posterImageView)
        
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
