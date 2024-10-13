//
//  TrendViewModel.swift
//  Moolog
//
//  Created by 여성은 on 10/13/24.
//

import Foundation

import RxCocoa
import RxSwift

final class TrendViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    let networkManager: NetworkType
    
    init(networkManager: NetworkType) {
        self.networkManager = networkManager
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let searchBtnTap: Observable<Void>
        let movieSelectedCell: Observable<Int>
        let seriesSelectedCell: Observable<Int>
    }
    struct Output {
        let serachBtnTap: Driver<Void>
        let movieList: Driver<[TrendingMovie]>
        let seriesList: Driver<[TrendingTV]>
        let randomMovie: Driver<TrendingMovie>
        let selectedMovieID: Driver<Int>
        let selectedSeriesID: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        let movieList = PublishRelay<[TrendingMovie]>()
        let seriesList = PublishRelay<[TrendingTV]>()
        let randomContent = PublishRelay<TrendingMovie>()
        
        let selectedMovieID = PublishRelay<Int>()
        let selectedSeriesID = PublishRelay<Int>()
        
        input.viewWillAppear
            .flatMap { [weak self] _ in
                guard let self = self else {
                    return Single.zip(
                        .just(Result<TrendingMovieResponse, NetworkError>
                            .failure(NetworkError.serverError)),
                        .just(Result<TrendingTVResponse, NetworkError>
                            .failure(NetworkError.serverError))
                    )
                }
                
                let trendMovieResult = networkManager.callRequest(
                    router: .trendingMovie,
                    type: TrendingMovieResponse.self
                )
                let trendSeriesResult = networkManager.callRequest(
                    router: .trendingTV,
                    type: TrendingTVResponse.self
                )
                                
                return Single.zip(
                    trendMovieResult,
                    trendSeriesResult
                )
            }
            .bind(with: self) { owner, results in
                let (
                    trendMovieResult,
                    trendSeriesResult
                ) = results
                
                switch trendMovieResult {
                case .success(let movie):
                    movieList.accept(movie.results)
                    randomContent.accept(movie.results[Int.random(in: 0...9)])
                case .failure(let error):
                    print(error)
                }
                switch trendSeriesResult {
                case .success(let series):
                    seriesList.accept(series.results)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.movieSelectedCell
            .bind(to: selectedMovieID)
            .disposed(by: disposeBag)
        
        input.seriesSelectedCell
            .bind(to: selectedSeriesID)
            .disposed(by: disposeBag)
        
        return Output(
            serachBtnTap: input.searchBtnTap.asDriver(onErrorJustReturn: ()),
            movieList: movieList.asDriver(onErrorJustReturn: []),
            seriesList: seriesList.asDriver(onErrorJustReturn: []), 
            randomMovie: randomContent.asDriver(
                onErrorJustReturn: TrendingMovie(
                id: 0,
                title: "",
                posterPath: ""
                )
            ),
            selectedMovieID: selectedMovieID.asDriver(onErrorJustReturn: 0),
            selectedSeriesID: selectedSeriesID.asDriver(onErrorJustReturn: 0)
        )
    }
}
