//
//  SimilarCollectionViewCell.swift
//  Moolog
//
//  Created by 아라 on 10/13/24.
//

import UIKit

import Kingfisher
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
    
    func configureUI(_ data: SimilarResult) {
        guard let posterPath = data.posterPath else { return }
        let url = "https://image.tmdb.org/t/p/original/" + posterPath
        posterImageView.kf.setImage(with: URL(string: url))
    }
}
