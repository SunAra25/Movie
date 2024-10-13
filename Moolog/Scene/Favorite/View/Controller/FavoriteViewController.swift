//
//  FavoriteViewController.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/12/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class FavoriteViewController: BaseNavigationViewController {
    var disposeBag = DisposeBag()
    private var favTableView = MediaTableView()
    private let viewModel = FavoriteViewModel()
    
    override func bind() {
        let input = FavoriteViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            selectedCell: favTableView.tableView.rx.itemSelected.map { $0.row },
            deleteCell: favTableView.tableView.rx.itemDeleted.map { $0.row }
        )
        let output = viewModel.transform(input: input)
        
        output.favMedia
            .drive(favTableView.tableView.rx.items(
                cellIdentifier: MediaTableViewCell.identifier,
                cellType: MediaTableViewCell.self
            )) { _, data, cell in
                cell.configureUI(
                    posterImg: String(data.id),
                    mediaTitle: data.title,
                    isSearch: false
                )
            }
            .disposed(by: disposeBag)
        
    }
    
    override func setNavigation() {
        super.setNavigation()
        
        title = Constant.NavigationTitle.searchTitle.rawValue
    }
    
    override func setHierarchy() {
        view.addSubview(favTableView)
    }
    
    override func setConstraints() {
        favTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
