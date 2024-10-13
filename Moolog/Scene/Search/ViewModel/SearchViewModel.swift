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
        let seachCancelled: Observable<Void>
    }
    
    struct Output {
        let trendMovie: Driver<[SearchTrendingSectionModel]>
        let searchedDataSources: Driver<[SearchMovieSectionModel]>
        let isSearched: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let trendMovie = PublishRelay<[SearchTrendingSectionModel]>()
        let searchedDataSource = BehaviorRelay<[SearchMovieSectionModel]>(value: [])
        let searchedOriginal = BehaviorRelay<SearchResponse>(value: .init(
            page: 0,
            results: [],
            totalPages: 0,
            totalResults: 0
        ))
        let isSearched = PublishRelay<Bool>()
        
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                owner.networkManager.callRequest(
                    router: .trendingMovie,
                    type: TrendingMovieResponse.self
                )
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        let sectionItems: [SectionItem] = [
                            .header(Constant.SectionHeader.recommend.rawValue)
                        ] + response.results.map { .movies($0) }
                        let sections = [SearchTrendingSectionModel(items: sectionItems)]
                        trendMovie.accept(sections)
                        
                        isSearched.accept(false)
                        
                    case .failure(let error):
                        print(error)
                        isSearched.accept(false)
                    }
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.searchedText
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
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
                        
                        isSearched.accept(true)
                    case .failure(let err):
                        print(err)
                        isSearched.accept(true)
                    }
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.seachCancelled
            .bind { _ in
                isSearched.accept(false)
            }
            .disposed(by: disposeBag)
        
        return Output(
            trendMovie: trendMovie.asDriver(onErrorJustReturn: []),
            searchedDataSources: searchedDataSource.asDriver(onErrorJustReturn: []),
            isSearched: isSearched.asDriver(onErrorJustReturn: false)
        )
    }
}
