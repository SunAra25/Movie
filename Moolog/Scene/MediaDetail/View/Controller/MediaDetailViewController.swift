//
//  MediaDetailViewController.swift
//  Moolog
//
//  Created by 아라 on 10/13/24.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift
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
        title: "저장",
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
    private lazy var creditCollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.creditLayout
        )
        view.register(
            CreditCollectionViewCell.self,
            forCellWithReuseIdentifier: CreditCollectionViewCell.identifier
        )
        view.backgroundColor = .clear
        return view
    }()
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "비슷한 콘텐츠"
        label.font = .sub
        label.textColor = .white
        return label
    }()
    private lazy var similarCollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.similarLayout
        )
        view.register(
            SimilarCollectionViewCell.self,
            forCellWithReuseIdentifier: SimilarCollectionViewCell.identifier
        )
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        return view
    }()
    private let creditLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: Constant.Numeric.horiSpacing.value,
            bottom: 0,
            right: Constant.Numeric.horiSpacing.value
        )
        return layout
    }()
    private let similarLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = Constant.Numeric.screenWidth.value
        let padding = Constant.Numeric.horiSpacing.value * 2
        let itemWidth = (screenWidth - padding - 8) / 3
        layout.itemSize = CGSize(
            width: itemWidth,
            height: itemWidth * 4 / 3
        )
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: Constant.Numeric.horiSpacing.value,
            bottom: 0,
            right: Constant.Numeric.horiSpacing.value
        )
        return layout
    }()
    let viewModel: MediaDetailViewModel
    let disposeBag: DisposeBag = DisposeBag()
    private var movieTitle = ""
    private var posterPath = ""
    
    init(movieID: Int) {
        self.viewModel = MediaDetailViewModel(
            movieID: movieID,
            manager: NetworkManager()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = MediaDetailViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            closeBtnTap: closeButton.rx.tap.asObservable(),
            playBtnTap: playButton.rx.tap.asObservable(),
            saveBtnTap: saveButton.rx.tap.map { [weak self] _ in
                guard let self else { return ("", "") }
                return (movieTitle, posterPath)
            }.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.movieDetail
            .drive { [weak self] response in
                guard let self else { return }
                let url = "https://image.tmdb.org/t/p/w400" + response.backdropPath
                titleLabel.text = response.title
                averageLabel.text = String(format: "%.1f", response.voteAverage) 
                overviewLabel.text = response.overview
                backdropImageView.kf.setImage(with: URL(string: url))
                movieTitle = response.title
                posterPath = response.posterPath
            }
            .disposed(by: disposeBag)
        
        output.creditList
            .drive(creditCollectionView.rx.items(
                cellIdentifier: CreditCollectionViewCell.identifier,
                cellType: CreditCollectionViewCell.self
            )) { _, element, cell in
                cell.configureUI(element)
            }
            .disposed(by: disposeBag)
        
        output.similarList
            .drive(similarCollectionView.rx.items(
                cellIdentifier: SimilarCollectionViewCell.identifier,
                cellType: SimilarCollectionViewCell.self
            )) { _, element, cell in
                cell.configureUI(element)
                self.similarCollectionView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        output.showVideoView
            .drive { _ in
                // TODO: 예고편 재생
            }
            .disposed(by: disposeBag)
        
        output.dismiss
            .drive { [weak self] _ in
                guard let self else { return }
                dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func setHierarchy() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [
            backdropImageView,
            closeView,
            titleLabel,
            averageLabel,
            playButton,
            saveButton,
            overviewLabel,
            creditCollectionView,
            headerLabel,
            similarCollectionView
        ].forEach {
            contentView.addSubview($0)
        }
        
        closeView.addSubview(closeButton)
    }
    
    override func setConstraints() {
        let screenWidth = Constant.Numeric.screenWidth.value
        let padding = Constant.Numeric.horiSpacing.value * 2
        let itemWidth = (screenWidth - padding - 8) / 3
        let itemHeight = itemWidth * 4 / 3
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview()
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
        }
        
        creditCollectionView.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(creditCollectionView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
                .inset(Constant.Numeric.horiSpacing.value)
        }
        
        similarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(itemHeight * 7 + 24)
        }
    }
}
