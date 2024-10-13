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
    
    private var totalPages: Int = 1
    private var currentPage: Int = 1
    private var latestSearchText: String = ""
    
    init(networkManager: NetworkType) {
        self.networkManager = networkManager
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let searchedText: Observable<String>
        let seachCancelled: Observable<Void>
        let cvSelectedCell: Observable<Int>
        let tvSelectedCell: Observable<Int>
        let prefetchItems: Observable<[IndexPath]>
    }
    
    struct Output {
        let trendMovie: Driver<[SearchTrendingSectionModel]>
        let searchedDataSources: Driver<[SearchMovieSectionModel]>
        let isSearched: Driver<Bool>
        let selectedMediaID: Driver<Int>
        let isEmptyResult: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let trendMovie = BehaviorRelay<[SearchTrendingSectionModel]>(value: [])
        let searchedDataSource = BehaviorRelay<[SearchMovieSectionModel]>(value: [])
        let isSearched = PublishRelay<Bool>()
        let selectedMediaID = PublishRelay<Int>()
        let isEmptyResult = PublishRelay<Bool>()
        
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
                owner.resetPages(text: text)
                searchedDataSource.accept([])
                
                owner.fetchSearchResults(
                    query: owner.latestSearchText,
                    page: owner.currentPage,
                    dataSource: searchedDataSource,
                    isSearched: isSearched,
                    isEmptyResult: isEmptyResult
                )
            }
            .disposed(by: disposeBag)
        
        input.seachCancelled
            .bind { _ in
                isSearched.accept(false)
            }
            .disposed(by: disposeBag)
        
        input.cvSelectedCell
            .bind(to: selectedMediaID)
            .disposed(by: disposeBag)
        
        input.tvSelectedCell
            .bind(to: selectedMediaID)
            .disposed(by: disposeBag)
        
        input.prefetchItems
            .withUnretained(self)
            .filter { owner, indexPathArray in
                if let indexPath = indexPathArray.first,
                   let searchedList = searchedDataSource.value.first {
                    return indexPath.row > searchedList.items.count - 5
                    && owner.currentPage < owner.totalPages
                } else {
                    return false
                }
            }
            .bind { viewModel, _ in
                viewModel.currentPage += 1
                
                viewModel.fetchSearchResults(
                    query: viewModel.latestSearchText,
                    page: viewModel.currentPage,
                    dataSource: searchedDataSource,
                    isSearched: isSearched,
                    isEmptyResult: isEmptyResult
                )
            }
            .disposed(by: disposeBag)
        
        return Output(
            trendMovie: trendMovie.asDriver(onErrorJustReturn: []),
            searchedDataSources: searchedDataSource.asDriver(onErrorJustReturn: []),
            isSearched: isSearched.asDriver(onErrorJustReturn: false),
            selectedMediaID: selectedMediaID.asDriver(onErrorJustReturn: 0),
            isEmptyResult: isEmptyResult.asDriver(onErrorJustReturn: false)
        )
    }
    private func fetchSearchResults(
        query: String,
        page: Int,
        dataSource: BehaviorRelay<[SearchMovieSectionModel]>,
        isSearched: PublishRelay<Bool>,
        isEmptyResult: PublishRelay<Bool>
    ) {
        networkManager.callRequest(
            router: .searchMovie(target: query, page: page),
            type: SearchResponse.self
        )
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let response):
                let searched = response.results.filter { $0.posterPath != nil }
                
                owner.fetchSearchResult(searched: searched, isEmptyResult: isEmptyResult)
                
                if page == 1 {
                    dataSource.accept([SearchMovieSectionModel(
                        header: "영화 & 시리즈",
                        items: searched)
                    ])
                } else {
                    var currentSections = dataSource.value
                    currentSections[0].items.append(contentsOf: searched)
                    dataSource.accept(currentSections)
                }
                
                owner.totalPages = response.totalPages
                isSearched.accept(true)
            case .failure(let err):
                print(err)
                isSearched.accept(true)
            }
        }
        .disposed(by: disposeBag)
    }
    private func resetPages(text: String) {
        totalPages = 1
        currentPage = 1
        latestSearchText = text
    }
    
    private func fetchSearchResult(
        searched: [SearchResult],
        isEmptyResult: PublishRelay<Bool>
    ) {
        let isEmpty = searched.isEmpty
        isEmptyResult.accept(isEmpty)
    }
}
