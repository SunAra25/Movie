//
//  RecentKeyword.swift
//  Moolog
//
//  Created by 여성은 on 10/11/24.
//

import Foundation

import RealmSwift

class RecentKeyword: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var keyword: String
    @Persisted var searchTime: Date
    
    convenience init(keyword: String, date: Date) {
        self.init()
        self.keyword = keyword
        self.searchTime = date
    }
}
