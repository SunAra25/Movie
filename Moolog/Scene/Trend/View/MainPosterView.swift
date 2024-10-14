//
//  MainPosterView.swift
//  Moolog
//
//  Created by 여성은 on 10/14/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class MainPosterView: BaseView {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 28
        view.clipsToBounds = true
//        view.isUserInteractionEnabled = true
        return view
    }()
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .body2
        label.textColor = .white
        return label
    }()
    let playButton = ImageButton(
        title: "재생",
        image: UIImage(systemName: "play.fill"),
        foreColor: .black,
        backColor: .white,
        radius: 8
    )
    let saveButton = ImageButton(
        title: "내가 찜한 리스트",
        image: UIImage(systemName: "plus"),
        foreColor: .white,
        backColor: .black,
        radius: 8
    )
    override func setLayout() {
        self.addSubview(imageView)
        self.addSubview(genreLabel)
        self.addSubview(playButton)
        self.addSubview(saveButton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.5)
        }
        genreLabel.snp.makeConstraints { make in
            make.bottom.equalTo(playButton.snp.top).offset(-12)
            make.leading.equalTo(imageView.snp.leading).offset(16)
            make.trailing.equalTo(imageView.snp.trailing).offset(-16)
        }
        playButton.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-16)
            make.leading.equalTo(imageView.snp.leading).offset(16)
            make.height.equalTo(36)
            make.width.equalTo(130)
        }
        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(playButton)
            make.leading.equalTo(playButton.snp.trailing).offset(8)
            make.trailing.equalTo(imageView.snp.trailing).offset(-16)
            make.height.equalTo(playButton.snp.height)
        }
        
        // MARK: TEST
        genreLabel.text = "애니메이션 가족 코미디 드라마"
        
    }
    func configureUI(_ data: TrendingMovie) {
        let url = URLConstant.imageURL + data.posterPath
        imageView.kf.setImage(with: URL(string: url))
    }
}
