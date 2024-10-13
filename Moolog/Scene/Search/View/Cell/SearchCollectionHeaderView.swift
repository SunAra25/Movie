//
//  SearchCollectionHeaderView.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/13/24.
//

import UIKit

import SnapKit

final class SearchCollectionHeaderView: BaseCollectionViewCell {
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = .head
        return label
    }()
    
    override func setUI() {
        contentView.addSubview(headerLabel)
    }
    
    override func setLayout() {
        headerLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
                .inset(Constant.Numeric.vertiSpacing.value)
            make.horizontalEdges.equalToSuperview()
                .inset(Constant.Numeric.horiSpacing.value)
        }
    }
    
    func setHeaderTitle(title: String) {
        headerLabel.text = title
    }
}
