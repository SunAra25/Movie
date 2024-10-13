//
//  TrendViewController.swift
//  Moolog
//
//  Created by 여성은 on 10/13/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class TrendViewController: BaseNavigationViewController {
    lazy var searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: nil
        )
        return button
    }()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainPosterView = MainPosterView()
    private let movieSectionLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.SectionHeader.risingMovie.rawValue
        label.font = .title
        label.textColor = .white
        return label
    }()
    private lazy var movieCollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.cvLayout
        )
        view.register(
            TrendMovieCollectionViewCell.self,
            forCellWithReuseIdentifier: TrendMovieCollectionViewCell.identifier
        )
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    private let tvSeriesSectionLabel: UILabel = {
            let label = UILabel()
        label.text = Constant.SectionHeader.risingSeries.rawValue
            label.font = .boldSystemFont(ofSize: 18)
            label.textColor = .white
            return label
        }()
    private lazy var seriesCollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.cvLayout
        )
        view.register(
            TrendSeriesCollectionViewCell.self,
            forCellWithReuseIdentifier: TrendSeriesCollectionViewCell.identifier
        )
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    private let cvLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = Constant.Numeric.screenWidth.value
        let padding = Constant.Numeric.horiSpacing.value * 2
        let itemWidth = (screenWidth - padding - 10 * 2) / 3
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(
            width: itemWidth,
            height: itemWidth * 1.5
        )
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: Constant.Numeric.horiSpacing.value,
            bottom: 0,
            right: Constant.Numeric.horiSpacing.value
        )
        return layout
    }()
    let viewModel = TrendViewModel(networkManager: NetworkManager())
    let disposeBag = DisposeBag()
    
    override func bind() {
        let input = TrendViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            searchBtnTap: searchButton.rx.tap.asObservable(),
            movieSelectedCell: movieCollectionView.rx.modelSelected(TrendingMovie.self)
                .map{ $0.id },
            seriesSelectedCell: seriesCollectionView.rx.modelSelected(TrendingTV.self)
                .map{ $0.id }
        )
        let output = viewModel.transform(input: input)
        
        output.randomMovie
            .drive(onNext: { [weak self] movie in
                        self?.mainPosterView.configureUI(movie)
                    })
            .disposed(by: disposeBag)
        output.movieList
            .drive(movieCollectionView.rx.items(
                cellIdentifier: TrendMovieCollectionViewCell.identifier,
                cellType: TrendMovieCollectionViewCell.self
            )) { _, element, cell in
                cell.configureUI(element)
            }
            .disposed(by: disposeBag)
        output.seriesList
            .drive(seriesCollectionView.rx.items(
                cellIdentifier: TrendSeriesCollectionViewCell.identifier,
                cellType: TrendSeriesCollectionViewCell.self
            )) { _, element, cell in
                cell.configureUI(element)
            }
            .disposed(by: disposeBag)
        
        output.selectedMovieID
            .drive(with: self) { _, id in
                print(id)
//                let vc = MediaDetailViewController(movieID: id)
//                vc.modalPresentationStyle = .fullScreen
//                show(nav, sender: self)
            }
            .disposed(by: disposeBag)
        output.selectedSeriesID
            .drive(with: self) { _, id in
                print(id)
//                let vc = MediaDetailViewController(movieID: id)
//                vc.modalPresentationStyle = .fullScreen
//                show(nav, sender: self)
            }
            .disposed(by: disposeBag)
    }
    
    override func setHierarchy() {
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
     
        contentView.addSubview(mainPosterView)
        contentView.addSubview(movieCollectionView)
        contentView.addSubview(seriesCollectionView)
    }
    
    override func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        mainPosterView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(mainPosterView.snp.width).multipliedBy(1.5)
        }
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainPosterView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        seriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(movieCollectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
            make.bottom.equalToSuperview().offset(-20)
        }

    }
    override func setNavigation() {
        super.setNavigation()
        navigationItem.rightBarButtonItem = searchButton
    }
}

//extension TrendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        numberOfItemsInSection section: Int
//    ) -> Int {
//        return 100
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: TrendMovieCollectionViewCell.identifier,
//            for: indexPath
//        ) as? TrendMovieCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//
//        return cell
//    }
//    
//    
//}
