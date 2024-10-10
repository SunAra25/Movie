//
//  TargetType.swift
//  Moolog
//
//  Created by Jisoo Ham on 10/10/24.
//

import Foundation

enum Scheme: String {
    case http, https
}

protocol TargetType {
    /// 네트워크 통신에서 말하는 HTTP protocol ex) http, https
    var scheme: Scheme { get }
    /// 도메인
    var host: String { get }
    /// 서버 식별을 위한 포트 넘버
    var port: Int? { get }
    /// 요청 경로
    var path: String { get }
    /// 각 통신마다 다르게 받을 요소
    var params: [String: Any] { get }
    /// HTTP request header ex) Authorization
    var header: [String: String] { get }
    /// get을 제외한 통신을 할 때 사용할 body
    var body: [String: Any]? { get }
    /// 서버에 request 보낼 때 어떤 작업을 요청하는지 의도를 담은
    var method: HTTPMethod { get }
}

extension TargetType {
    var toURLRequest: URLRequest? {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme.rawValue
        urlComponent.host = host
        urlComponent.port = port
        urlComponent.path = path
        
        if !params.isEmpty {
            urlComponent.queryItems = params.map {
                URLQueryItem(
                    name: $0.key,
                    value: $0.value as? String
                )
            }
        }
        
        guard let url = urlComponent.url else {
            print(#function, "URL Error")
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header
        
        if let body = body,
            method != .get {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return urlRequest
    }
}
