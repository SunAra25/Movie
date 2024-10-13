//
//  SearchViewController.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/13/24.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class SearchViewController: BaseNavigationViewController {
    var disposeBag: DisposeBag = DisposeBag()
    private var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "시리즈 및 영화를 검색해보세요"
        return search
    }()
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout()
        )
        view.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.identifier
        )
        view.register(
            SearchCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchCollectionHeaderView.identifier
        )
        return view
    }()
    
    private let viewModel = SearchViewModel(networkManager: NetworkManager())
    
    override func setNavigation() {
        super.setNavigation()
        
        navigationItem.searchController = searchController
    }
    
    override func bind() {
        let searchedText = searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(
                searchController.searchBar.rx.text.orEmpty
            ) { (_, searchText) in
                return searchText
            }
        
        let input = SearchViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            searchedText: searchedText
        )
        let output = viewModel.transform(input: input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource
        <SearchMovieSectionModel> { _, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SearchCollectionViewCell.identifier,
                for: indexPath
            ) as? SearchCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setImage(posterPath: item.posterPath ?? "")
            
            return cell
        } configureSupplementaryView: { dataSource, collectionView, text, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: text,
                withReuseIdentifier: SearchCollectionHeaderView.identifier,
                for: indexPath
            ) as? SearchCollectionHeaderView else { return UICollectionViewCell() }
            
            header.setHeaderTitle(title: dataSource[indexPath.section].header)
            
            return header
        }
        
        output.searchedDataSources
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func setHierarchy() {
        [collectionView]
            .forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(4.0 / 9.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        section.interGroupSpacing = 10

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
