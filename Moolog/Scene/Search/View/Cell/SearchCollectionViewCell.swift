//
//  SearchCollectionViewCell.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/13/24.
//

import UIKit

import Kingfisher
import SnapKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    private var posterImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = Constant.Numeric.vertiSpacing.value
        view.clipsToBounds = true
        return view
    }()
    
    override func setUI() {
        contentView.addSubview(posterImg)
    }
    
    override func setLayout() {
        posterImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setImage(posterPath: String) {
        posterImg.kf.setImage(with: URL(string: URLConstant.imageURL + posterPath))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImg.image = nil
        posterImg.layer.cornerRadius = Constant.Numeric.vertiSpacing.value
        posterImg.clipsToBounds = true
        posterImg.contentMode = .scaleAspectFill
    }
}
