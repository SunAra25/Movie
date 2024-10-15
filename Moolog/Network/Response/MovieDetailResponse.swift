//
//  MovieDetailResponse.swift
//  Moolog
//
//  Created by 아라 on 10/11/24.
//

import Foundation

struct MovieDetailResponse: Codable {
    let title: String
    let backdropPath: String
    let genres: [Genre]
    let id: Int
    let overview: String
    let posterPath: String
    let video: Bool
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case title
        case backdropPath = "backdrop_path"
        case genres, id
        case overview
        case posterPath = "poster_path"
        case video
        case voteAverage = "vote_average"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
