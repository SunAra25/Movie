//
//  SearchMovieSectionModel.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/13/24.
//

import Foundation

import RxDataSources

struct SearchMovieSectionModel {
    var header: String
    var items: [Item]
}

extension SearchMovieSectionModel: SectionModelType {
    typealias Item = SearchResult

    init(original: SearchMovieSectionModel, items: [SearchResult]) {
        self = original
        self.items = items
    }
}
