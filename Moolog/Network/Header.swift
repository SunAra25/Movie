//
//  Header.swift
//  Moolog
//
//  Created by 아라 on 10/11/24.
//

import Foundation

struct Header {
    static let hasAPIKeyHeader = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "Key") as? String
        else { fatalError("Key not found in Info.plist") }
        return ["Authorization": key]
    }()
    
    static let hasJsonHeader = {
        return ["accept": "application/json"]
    }()
    
    static func merging(_ headers: [String: String]...) -> [String: String] {
        headers.reduce(into: [String: String]()) { result, header in
            result.merge(header) { current, _ in current }
        }
    }
}
