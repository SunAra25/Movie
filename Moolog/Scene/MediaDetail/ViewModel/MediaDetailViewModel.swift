//
//  MediaDetailViewModel.swift
//  Moolog
//
//  Created by 아라 on 10/13/24.
//

import Foundation

import RxCocoa
import RxSwift

final class MediaDetailViewModel: ViewModelType {
    var disposeBag: DisposeBag =  DisposeBag()
    let movieID: Int
    let manager: NetworkType
    private let favRepository = FavoriteMovieRepository()
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let closeBtnTap: Observable<Void>
        let playBtnTap: Observable<Void>
        let saveBtnTap: Observable<(String, String)>
    }
    
    struct Output {
        let movieDetail: Driver<MovieDetailResponse>
        let creditList: Driver<[Cast]>
        let similarList: Driver<[SimilarResult]>
        let showVideoView: Driver<Void>
        let showAlert: Driver<String>
        let dismiss: Driver<Void>
    }
    
    init(
        movieID: Int,
        manager: NetworkType
    ) {
        self.movieID = movieID
        self.manager = manager
    }
    
    func transform(input: Input) -> Output {
        let movieDetail = PublishRelay<MovieDetailResponse>()
        let creditList = PublishRelay<[Cast]>()
        let similarList = PublishRelay<[SimilarResult]>()
        let showAlert = PublishRelay<String>()
        
        input.viewWillAppear
            .flatMap { [weak self] _ in
                guard let self = self else {
                    return Single.zip(
                        .just(Result<MovieDetailResponse, NetworkError>
                            .failure(NetworkError.serverError)),
                        .just(Result<CreditsResponse, NetworkError>
                            .failure(NetworkError.serverError)),
                        .just((Result<SimilarMovieResponse, NetworkError>
                            .failure(NetworkError.serverError)))
                    )
                }
                
                let detailResult = manager.callRequest(
                    router: .detail(movieID: movieID),
                    type: MovieDetailResponse.self
                )
                let creditResult = manager.callRequest(
                    router: .credits(movieID: movieID),
                    type: CreditsResponse.self
                )
                let similarResult = manager.callRequest(
                    router: .similarMovie(movieID: movieID),
                    type: SimilarMovieResponse.self
                )
                
                return Single.zip(
                    detailResult,
                    creditResult,
                    similarResult
                )
            }
            .bind(with: self) { owner, results in
                let (
                    detailResult,
                    creditResult,
                    similarResult
                ) = results
                
                switch detailResult {
                case .success(let detail):
                    movieDetail.accept(detail)
                case .failure(let error):
                    print(error)
                }
                
                switch creditResult {
                case .success(let credit):
                    creditList.accept(credit.cast)
                case .failure(let error):
                    print(error)
                }
                
                switch similarResult {
                case .success(let similar):
                    similarList.accept(similar.results)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.saveBtnTap
            .bind(with: self) { owner, values in
                let (title, path) = values
                
                if owner.favRepository.fetchData()
                    .contains(where: { $0.id == owner.movieID }) {
                    showAlert.accept(Constant.AlertTitle.already.rawValue)
                } else {
                    owner.saveMovie(title: title, path: path)
                    showAlert.accept(Constant.AlertTitle.saved.rawValue)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            movieDetail: movieDetail.asDriver(onErrorDriveWith: .empty()),
            creditList: creditList.asDriver(onErrorJustReturn: []),
            similarList: similarList.asDriver(onErrorJustReturn: []),
            showVideoView: input.playBtnTap.asDriver(onErrorDriveWith: .empty()), 
            showAlert: showAlert.asDriver(onErrorDriveWith: .empty()),
            dismiss: input.closeBtnTap.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    func saveMovie(title: String, path: String) {
        Task {
            await FileStorage.saveImageToDocument(
                image: path,
                filename: String(movieID)
            )
        }
        
        favRepository.createItem(.init(
            id: movieID,
            title: title
        ))
    }
}
