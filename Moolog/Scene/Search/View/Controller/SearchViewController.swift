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
    private lazy var trendingTableView = MediaTableView()
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
        
        let tvSelected = trendingTableView.tableView.rx.modelSelected(SectionItem.self)
            .map { item in
                switch item {
                case .movies(let data):
                    return data.id
                default:
                    return nil
                }
            }
            .compactMap { $0 }
        
        let cvDataSource = makeCollectionViewDataSource()
        let tvDataSource = makeTableViewDataSource()
        
        let input = SearchViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            searchedText: searchedText,
            seachCancelled: searchController.searchBar.rx.cancelButtonClicked
                .map { _ in () },
            cvSelectedCell: collectionView.rx.itemSelected
                .map { cvDataSource[0].items[$0.item].id },
            tvSelectedCell: tvSelected,
            prefetchItems: collectionView.rx.prefetchItems.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.trendMovie
            .drive(trendingTableView.tableView.rx.items(dataSource: tvDataSource))
            .disposed(by: disposeBag)
        
        output.searchedDataSources
            .drive(collectionView.rx.items(dataSource: cvDataSource))
            .disposed(by: disposeBag)
        
        output.isSearched
            .drive(with: self) { owner, isSearched in
                if isSearched {
                    owner.trendingTableView.isHidden = true
                    owner.collectionView.isHidden = false
                } else {
                    owner.trendingTableView.isHidden = false
                    owner.collectionView.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        output.selectedMediaID
            .drive(with: self) { _, mediaID in
                print(mediaID)
//                let vc = owner.navigationController?.pushViewController(
//                    <#T##viewController: UIViewController##UIViewController#>,
//                    animated: true
//                )
            }
            .disposed(by: disposeBag)
        
    }
    
    override func setHierarchy() {
        [
            trendingTableView,
            collectionView
        ]
            .forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        trendingTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func makeCollectionViewDataSource()
    -> RxCollectionViewSectionedReloadDataSource<SearchMovieSectionModel> {
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
        
        return dataSource
    }
    
    private func makeTableViewDataSource()
    -> RxTableViewSectionedReloadDataSource<SearchTrendingSectionModel> {
        let tableDataSource = RxTableViewSectionedReloadDataSource
        <SearchTrendingSectionModel> { _, tableView, indexPath, item in
            tableView.rowHeight = indexPath.row == 0 ? 50 : 110
            
            switch item {
            case .header(let title):
                guard let headerCell = tableView.dequeueReusableCell(
                    withIdentifier: MediaTableHeaderCell.identifier,
                    for: indexPath
                ) as? MediaTableHeaderCell else { return UITableViewCell() }
                
                headerCell.setUI(title: title)
                
                return headerCell
            case .movies(let data):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: MediaTableViewCell.identifier,
                    for: indexPath
                ) as? MediaTableViewCell else { return UITableViewCell() }
                
                cell.configureUI(
                    posterImg: data.posterPath,
                    mediaTitle: data.title,
                    isSearch: true
                )
                
                return cell
            }
        }
        return tableDataSource
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
