//
//  TrendCollectionViewCell.swift
//  Moolog
//
//  Created by 여성은 on 10/13/24.
//
import UIKit

import Kingfisher
import SnapKit

final class TrendMovieCollectionViewCell: BaseCollectionViewCell {
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

    func configureUI(_ data: TrendingMovie) {
        let url = "https://image.tmdb.org/t/p/original/" + data.posterPath
        posterImageView.kf.setImage(with: URL(string: url))
    }
}
