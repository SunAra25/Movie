//
//  FavoriteMovieRepository.swift
//  Moolog
//
//  Created by 여성은 on 10/11/24.
//

import Foundation

import RealmSwift

final class FavoriteMovieRepository {
    private let realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Realm 초기화 실패")
        }
    }
    
    func getFileURL() {
        guard let fileURL = realm.configuration.fileURL else { return }
        print(fileURL)
    }
    
    func fetchData() -> [FavoriteMovie] {
        let value = realm.objects(FavoriteMovie.self).sorted(
            byKeyPath: "createDate",
            ascending: true
        )
        return Array(
            value
        )
    }
    
    func createItem(_ data: FavoriteMovie) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Realm Create Error")
        }
    }
    
    func deleteItem(_ id: Int) {
        do {
            try realm.write {
                realm.delete(realm.objects(FavoriteMovie.self).filter("id=%@", id))
            }
        } catch {
            print("Realm Delet Error")
        }
    }
    
}
