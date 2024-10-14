//
//  FavoriteMovie.swift
//  Moolog
//
//  Created by 여성은 on 10/11/24.
//

import Foundation

import RealmSwift

enum MediaType: String, PersistableEnum {
    case movie
    case series
}

class FavoriteMovie: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var createDate: Date
    @Persisted var mediaType: MediaType
    
    convenience init(id: Int, title: String) {
        self.init()
        self.id = id
        self.title = title
        self.createDate = Date()
    }
}
