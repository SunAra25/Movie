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
        type: T.Type
    ) -> Single<Result<T, NetworkError>>
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
        type: T.Type
    ) -> Single<Result<T, NetworkError>> {
        return Single.create { observer -> Disposable in
            guard let urlRequest = router.toURLRequest else {
                observer(.success(.failure(NetworkError.unkwonedError)))
                return Disposables.create()
            }
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: urlRequest) { data, response, error in
                if error != nil {
                    observer(.success(.failure(NetworkError.unkwonedError)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    observer(.success(.failure(.invalidResponse)))
                    return
                }
                
                guard 200..<300 ~= response.statusCode else {
                    observer(.success(.failure(.serverError)))
                    return
                }
                
                guard let data else {
                    observer(.success(.failure(.noData)))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(.success(result)))
                } catch {
                    observer(.success(.failure(.decodingError)))
                }
            }
            
            task.resume()
            
            return Disposables.create()
        }
    }
}
