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
        // TODO: URLConstants 생기면 삭제해야함
        let imageURL = "https://image.tmdb.org/t/p/original"
        posterImg.kf.setImage(with: URL(string: imageURL + posterPath))
    }
}
