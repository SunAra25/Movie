//
//  Router.swift
//  Moolog
//
//  Created by 아라 on 10/11/24.
//

import Foundation

enum Router {
    case trendingMovie
    case trendingTV
    case searchMovie(target: String)
    case credits(movieID: Int)
    case similarMovie(movieID: Int)
    case detail(movieID: Int)
}

extension Router: TargetType {
    var scheme: Scheme {
        return .https
    }
    
    var host: String {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String
        else { fatalError("BaseURL not found in Info.plist") }
        return baseURL
    }
    
    var port: Int? {
        return nil
    }
    
    var path: String {
        switch self {
        case .trendingMovie:
            return URLConstant.trendingMovie
        case .trendingTV:
            return URLConstant.trendingTV
        case .searchMovie(let target):
            return URLConstant.searchMovie
        case .credits(let movieID):
            return URLConstant.movie + "/\(movieID)" + URLConstant.credits
        case .similarMovie(let movieID):
            return URLConstant.movie + "/\(movieID)" + URLConstant.similar
        case .detail(let movieID):
            return URLConstant.movie + "/\(movieID)"
        }
    }
    
    var params: [String: Any] {
        return [:]
    }
    
    var header: [String: String] {
        return Header.merging(Header.hasJsonHeader, Header.hasAPIKeyHeader)
    }
    
    var body: [String: Any]? {
        nil
    }
    
    var method: HTTPMethod {
        return .get
    }
}
