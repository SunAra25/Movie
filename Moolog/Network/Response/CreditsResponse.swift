//
//  CreditsResponse.swift
//  Moolog
//
//  Created by 아라 on 10/11/24.
//

import Foundation

struct CreditsResponse: Decodable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Decodable {
    let id: Int
    let originalName: String
    let profilePath: String?
    let castID: Int?
    let character: String?

    enum CodingKeys: String, CodingKey {
        case id
        case originalName = "original_name"
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
    }
}
