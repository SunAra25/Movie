//
//  TrendingTVResponse.swift
//  Moolog
//
//  Created by 아라 on 10/11/24.
//

import Foundation

struct TrendingTVResponse: Decodable {
    let results: [TrendingTV]
}

struct TrendingTV: Codable {
    let id: Int
    let posterPath: String

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
    }
}
