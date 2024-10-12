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
    case searchMovie(target: String, page: Int)
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
            return URLConstant.version + URLConstant.trendingMovie
        case .trendingTV:
            return URLConstant.version + URLConstant.trendingTV
        case .searchMovie:
            return URLConstant.version + URLConstant.searchMovie
        case .credits(let movieID):
            return URLConstant.version 
            + URLConstant.movie
            + "/\(movieID)"
            + URLConstant.credits
        case .similarMovie(let movieID):
            return URLConstant.version
            + URLConstant.movie
            + "/\(movieID)"
            + URLConstant.similar
        case .detail(let movieID):
            return URLConstant.version + URLConstant.movie + "/\(movieID)"
        }
    }
    
    var params: [String: Any] {
        switch self {
        case .searchMovie(let target, let page):
            return [
                "language": "ko-KR",
                "query": target,
                "include_adult": true,
                "page": "\(page)"
            ]
        default: 
            return ["language": "ko-KR"]
        }
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
