//
//  MediaHeaderView.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/11/24.
//

import UIKit

import SnapKit

final class MediaHeaderView: UITableViewHeaderFooterView {
    static let identifier: String = "MediaHeaderView"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .head
        label.textColor = .white
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setUI(title: String) {
        titleLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
}
