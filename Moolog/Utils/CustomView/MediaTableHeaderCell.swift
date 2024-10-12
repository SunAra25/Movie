//
//  MediaTableHeaderCell.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/12/24.
//

import UIKit

import SnapKit

final class MediaTableHeaderCell: BaseTableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    override func setLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(8)
        }
    }
    
    func setUI(title: String) {
        titleLabel.text = title
    }
}
