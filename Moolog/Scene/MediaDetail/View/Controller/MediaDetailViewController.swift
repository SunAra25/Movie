//
//  MediaDetailViewController.swift
//  Moolog
//
//  Created by 아라 on 10/13/24.
//

import UIKit

import SnapKit

final class MediaDetailViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let closeView: UIView = {
        let view = UIView()
        view.backgroundColor = .baseBG.withAlphaComponent(0.8)
        view.layer.cornerRadius = 16
        return view
    }()
    private let closeButton = ImageButton(
        image: UIImage(systemName: "xmark"),
        foreColor: .white
    )
    private let backdropImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .head
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    private let averageLabel: UILabel = {
        let label = UILabel()
        label.font = .caption
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    private let playButton = ImageButton(
        title: "재생",
        image: UIImage(systemName: "play.fill"),
        foreColor: .black,
        backColor: .white,
        radius: 8
    )
    private let saveButton = ImageButton(
        title: "재생",
        image: UIImage(systemName: "square.and.arrow.down"),
        foreColor: .white,
        backColor: .baseBG,
        radius: 8
    )
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .body2
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override func setHierarchy() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [
            closeView,
            backdropImageView,
            titleLabel,
            averageLabel,
            playButton,
            saveButton,
            overviewLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        closeView.addSubview(closeButton)
    }
    
    override func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        backdropImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        closeView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
                .inset(Constant.Numeric.vertiSpacing.value)
            make.size.equalTo(32)
        }
        
        closeButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constant.Numeric.buttonHeight.value)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom)
                .offset(Constant.Numeric.vertiSpacing.value)
            make.horizontalEdges.equalToSuperview()
                .inset(Constant.Numeric.horiSpacing.value)
        }
        
        averageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
                .inset(Constant.Numeric.horiSpacing.value)
        }
        
        playButton.snp.makeConstraints { make in
            make.top.equalTo(averageLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
                .inset(Constant.Numeric.horiSpacing.value)
            make.height.equalTo(Constant.Numeric.buttonHeight.value)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
                .inset(Constant.Numeric.horiSpacing.value)
            make.height.equalTo(Constant.Numeric.buttonHeight.value)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
                .inset(Constant.Numeric.horiSpacing.value)
            make.bottom.equalToSuperview()
        }
    }
}
