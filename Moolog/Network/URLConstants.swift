//
//  URLConstants.swift
//  Moolog
//
//  Created by 아라 on 10/11/24.
//

import Foundation

struct URLConstant {
    // MARK: Base
    static let BaseURL: String = {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String
        else { fatalError("BaseURL not found in Info.plist") }
        return baseURL
    }()
    static let imageURL: String = "https://image.tmdb.org/t/p/original"
    private init() { }
    
    static let version = "/3"
    static let trending = "/trending"
    static let movie = "/movie"
    static let search = "/search"
    static let credits = "/credits"
    static let similar = "/similar"
    
    static let trendingMovie = URLConstant.trending + URLConstant.movie + "/day"
    static let trendingTV = URLConstant.trending + "/tv" + "/day"
    
    static let searchMovie = URLConstant.search + URLConstant.movie
}
