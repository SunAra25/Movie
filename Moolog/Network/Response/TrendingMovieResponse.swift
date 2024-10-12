//
//  TrendingMovieResponse.swift
//  Moolog
//
//  Created by 아라 on 10/11/24.
//

import Foundation

struct TrendingMovieResponse: Decodable {
    let results: [TrendingMovie]
}

struct TrendingMovie: Codable {
    let id: Int
    let title, posterPath: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
    }
}
