//
//  MainPosterView.swift
//  Moolog
//
//  Created by 여성은 on 10/14/24.
//

import UIKit

import Kingfisher
import SnapKit

final class MainPosterView: BaseView {
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 28
        view.clipsToBounds = true
        return view
    }()
    let genreLabel: UILabel = {
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
        foreColor: .black,
        backColor: .white,
        radius: 8
    )
    override func setLayout() {
        self.addSubview(imageView)
        imageView.addSubview(genreLabel)
        imageView.addSubview(playButton)
        imageView.addSubview(saveButton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
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
            make.height.equalTo(44)
            make.width.equalTo(120)
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
}
