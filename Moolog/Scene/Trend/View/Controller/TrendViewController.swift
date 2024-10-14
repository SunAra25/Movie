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
        button.tintColor = .white
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
                .map { $0.id },
            seriesSelectedCell: seriesCollectionView.rx.modelSelected(TrendingTV.self)
                .map { $0.id }, 
            saveBtnTap: self.mainPosterView.saveButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.serachBtnTap
            .drive(with: self) { _, _ in
                let vc = SearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
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
            .drive(with: self) { owner, id in
                print(id)
                let vc = MediaDetailViewController(movieID: id)
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        output.alertString
            .drive(with: self) { owner, value in
                owner.showAlert(title: value)
            }
            .disposed(by: disposeBag)
//        output.selectedSeriesID
//            .drive(with: self) { owner, id in
//                print(id)
//                let vc = MediaDetailViewController(movieID: id)
//                owner.present(vc, animated: true)
//            }
//            .disposed(by: disposeBag)
    }
    
    override func setHierarchy() {
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
     
        contentView.addSubview(mainPosterView)
        contentView.addSubview(movieSectionLabel)
        contentView.addSubview(movieCollectionView)
        contentView.addSubview(tvSeriesSectionLabel)
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
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(mainPosterView.snp.width).multipliedBy(1.5)
        }
        movieSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainPosterView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(movieSectionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        tvSeriesSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(movieCollectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        seriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tvSeriesSectionLabel.snp.bottom).offset(20)
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

extension TrendViewController {
    
    func showAlert(title: String) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        let okay = UIAlertAction(
            title: "확인",
            style: .default
        )
        
        alert.addAction(okay)
        
        present(alert, animated: true)
    }
}
