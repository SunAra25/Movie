//
//  SearchViewModel.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/13/24.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    let networkManager: NetworkType
    
    init(networkManager: NetworkType) {
        self.networkManager = networkManager
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let searchedText: Observable<String>
    }
    
    struct Output {
        let trendMovie: Driver<[TrendingMovie]>
        let searchedDataSources: Driver<[SearchMovieSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        let trendMovie = PublishRelay<[TrendingMovie]>()
        let searchedDataSource = BehaviorRelay<[SearchMovieSectionModel]>(value: [])
        
        input.searchedText
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                print(owner, text, "🔥")
                owner.networkManager.callRequest(
                    router: .searchMovie(target: text, page: 1),
                    type: SearchResponse.self
                )
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        let searched = response.results.filter { $0.posterPath != nil }
                        searchedDataSource.accept([SearchMovieSectionModel(
                            header: "영화 & 시리즈",
                            items: searched
                        )])
                    case .failure(let err):
                        print(err)
                    }
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(
            trendMovie: trendMovie.asDriver(onErrorJustReturn: []),
            searchedDataSources: searchedDataSource.asDriver(onErrorJustReturn: [])
        )
    }
}
