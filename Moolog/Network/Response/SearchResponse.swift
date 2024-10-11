//
//  SearchResponse.swift
//  Moolog
//
//  Created by 아라 on 10/11/24.
//

import Foundation

struct SearchResponse: Decodable {
    let page: Int
    let results: [SearchResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct SearchResult: Decodable {
    let id: Int
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
    }
}
