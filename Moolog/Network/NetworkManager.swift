//
//  NetworkManager.swift
//  Moolog
//
//  Created by 아라 on 10/11/24.
//

import Foundation

import RxSwift

protocol NetworkType {
    func callRequest<T: Decodable>(
        router: Router,
        type: T.Type,
        completion: @escaping (Single<Result<T, NetworkError>>) -> Void
    )
}

enum NetworkError: Error {
    case invalidResponse
    case invalidError
    case noData
    case decodingError
    case serverError
    case unkwonedError
}

class NetworkManager: NetworkType {
    func callRequest<T: Decodable>(
        router: Router,
        type: T.Type,
        completion: @escaping (Single<Result<T, NetworkError>>) -> Void
    ) {
        guard let urlRequest = router.toURLRequest else {
            completion(Single.just(.failure(.unkwonedError)))
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(Single.just(.failure(.unkwonedError)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(Single.just(.failure(.invalidResponse)))
                return
            }
            
            guard 200..<300 ~= response.statusCode else {
                completion(Single.just(.failure(.serverError)))
                return
            }
            
            guard let data else {
                completion(Single.just(.failure(.noData)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(Single.just(.success(result)))
            } catch {
                completion(Single.just(.failure(.decodingError)))
            }
        }
        
        task.resume()
    }
}
