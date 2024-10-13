//
//  MediaTableViewCell.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/11/24.
//

import UIKit

import Kingfisher
import SnapKit

final class MediaTableViewCell: BaseTableViewCell {
    private var posterView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private var mediaTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .body1
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    override func setLayout() {
        [
            posterView,
            mediaTitleLabel
        ]
            .forEach { contentView.addSubview($0) }
        
        posterView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.verticalEdges.equalToSuperview()
                .inset(Constant.Numeric.vertiSpacing.value)
            make.leading.equalToSuperview().inset(Constant.Numeric.horiSpacing.value)
            make.width.equalTo(posterView.snp.height).multipliedBy(1.25)
        }
        
        mediaTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(posterView.snp.trailing)
                .inset(-Constant.Numeric.vertiSpacing.value) // img를 기준으로 12만큼
            make.trailing.equalToSuperview().inset(Constant.Numeric.vertiSpacing.value)
        }
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterView.image = nil
        mediaTitleLabel.text = nil
    }
    
    func configureUI(posterImg: String, mediaTitle: String, isSearch: Bool) {
        if isSearch {
            posterView.kf.setImage(with: URL(string: URLConstant.imageURL + posterImg))
        } else {
            posterView.image = FileStorage.loadImageToDocument(filename: posterImg)
        }
        mediaTitleLabel.text = mediaTitle
    }
}
