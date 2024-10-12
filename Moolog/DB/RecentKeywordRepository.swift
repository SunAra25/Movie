//
//  RecentKeywordRepository.swift
//  Moolog
//
//  Created by 여성은 on 10/12/24.
//

import Foundation

import RealmSwift

final class RecentKeywordRepository {
    private let realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Realm 초기화 실패")
        }
    }

    func fetchData() -> [RecentKeyword] {
        let value = realm.objects(RecentKeyword.self).sorted(
            byKeyPath: "searchTime",
            ascending: false
        )
        return Array(value)
    }
    
    func createItem(_ data: RecentKeyword) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Realm Create Error")
        }
    }
    
    func deleteItem(_ id: ObjectId) {
        do {
            try realm.write {
                realm.delete(realm.objects(RecentKeyword.self).filter("id=%@", id))
            }
        } catch {
            print("Realm Delet Error")
        }
    }
    
}
