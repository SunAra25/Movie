//
//  MediaTableView.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/11/24.
//

import UIKit

import RxSwift
import SnapKit

final class MediaTableView: BaseView {
    var tableView: UITableView = {
        let view = UITableView()
        view.register(
            MediaTableViewCell.self,
            forCellReuseIdentifier: MediaTableViewCell.identifier
        )
        view.register(
            MediaTableHeaderCell.self,
            forCellReuseIdentifier: MediaTableHeaderCell.identifier
        )
        return view
    }()
    
    override func setLayout() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
