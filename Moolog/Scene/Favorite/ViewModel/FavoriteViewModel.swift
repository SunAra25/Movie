//
//  FavoriteViewModel.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/13/24.
//

import Foundation

import RxSwift
import RxCocoa

final class FavoriteViewModel: ViewModelType {
    var disposeBag: DisposeBag =  DisposeBag()
    private let favRepository = FavoriteMovieRepository()
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let selectedCell: Observable<Int>
        let deleteCell: Observable<Int>
    }
    
    struct Output {
        let favMedia: Driver<[FavoriteMovie]>
        let selectedMediaID: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        let medias = BehaviorRelay<[FavoriteMovie]>(value: [])
        let mediaID = PublishRelay<Int>()
        
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                let favMedia = owner.favRepository.fetchData()
                medias.accept(favMedia)
            }
            .disposed(by: disposeBag)
        
        input.selectedCell
            .bind(with: self) { _, index in
                mediaID.accept(medias.value[index].id)
            }
            .disposed(by: disposeBag)
        
        input.deleteCell
            .bind(with: self) { owner, index in
//                FileStorage.removeImageFromDocument(filename: medias.value[index].id)
                owner.favRepository.deleteItem(medias.value[index].id)
                
                let favMedia = owner.favRepository.fetchData()
                medias.accept(favMedia)
            }
            .disposed(by: disposeBag)
        
        return Output(
            favMedia: medias.asDriver(onErrorJustReturn: []),
            selectedMediaID: mediaID.asDriver(onErrorJustReturn: 0001)
        )
    }
}
