//
//  SearchTrendingSectionModel.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/13/24.
//

import Foundation

import RxDataSources

enum SectionItem {
    case header(String)
    case movies(TrendingMovie)
}

struct SearchTrendingSectionModel {
    var items: [Item]
}

extension SearchTrendingSectionModel: SectionModelType {
    typealias Item = SectionItem
    init(
        original: SearchTrendingSectionModel,
        items: [SectionItem]
    ) {
        self = original
        self.items = items
    }
}
