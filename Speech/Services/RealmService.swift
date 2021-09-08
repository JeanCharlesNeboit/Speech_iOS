//
//  RealmService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import Foundation
import SwiftyKit
import RealmSwift

typealias WriteResult = Result<Void, Error>

class RealmService {
    // MARK: - Singleton
    static var `default` = RealmService()
    
    // MARK: - Properties
    private var realm: Realm
    
    // MARK: - Initialization
    init() {
        do {
            realm = try Realm()
        } catch let error {
            NSLog("Failed to instanciate database: \(error.localizedDescription)")
            fatalError()
        }
    }
    
    convenience init(realm: Realm) {
        self.init()
        self.realm = realm
    }
    
    // MARK: File Path
    func printDatabaseFilePath() {
        realm.printFilePath()
    }
    
    // MARK: -
    func beginWrite() {
        if realm.isInWriteTransaction == false {
            realm.beginWrite()
        }
    }
    
    func cancelWrite() {
        if realm.isInWriteTransaction == true {
            realm.cancelWrite()
        }
    }
    
    func commitWrite() throws {
        if realm.isInWriteTransaction == true {
            try realm.commitWrite()
        }
    }
    
    func commit(completion: ((WriteResult) -> Void)?) {
        perform(transaction: commitWrite, completion: completion)
    }
    
    func write(block: () -> Void, completion: ((WriteResult) -> Void)? = nil) {
        let write: (() throws -> Void) = {
            try self.realm.write(block)
        }
        perform(transaction: write, completion: completion)
    }
    
    private func perform(transaction: (() throws -> Void), completion: ((WriteResult) -> Void)?) {
        do {
            try transaction()
            completion?(.success(()))
        } catch let error {
            NSLog("❌ Transaction could not be written. (\(error.localizedDescription))")
            completion?(.failure(error))
        }
    }
    
    // MARK: - Request
    func all<T>(_ type: T.Type) -> Results<T> where T: RealmSwift.Object {
        return realm.objects(type)
    }
    
    func addObject<T: Object>(_ object: T, completion: ((WriteResult) -> Void)? = nil) {
        addObjects([object], completion: completion)
    }
    
    func addObjects<T: Object>(_ objects: [T], completion: ((WriteResult) -> Void)? = nil) {
        beginWrite()
        realm.add(objects, update: .all)
        commit(completion: completion)
    }
    
    func deleteObject<T: Object>(_ object: T, completion: ((WriteResult) -> Void)? = nil, cascade: Bool = false) {
        beginWrite()
        if cascade {
            realm.deleteCascade(object)
        } else {
            realm.delete(object)
        }
        commit(completion: completion)
    }
}

extension RealmService {
    func allMessagesResult() -> Results<Message> {
        all(Message.self)
    }
    
    func allMessagesResult(category: Category?) -> Results<Message> {
        let result = allMessagesResult()
        if let category = category {
            return result.filter("\(#keyPath(Message.category)) == %@", category)
        } else {
            return result.filter("\(#keyPath(Message.category)) == nil")
        }
    }
    
    func doesMessageAlreadyExist(text: String) -> Bool {
        return allMessagesResult().contains(where: { $0.text == text })
    }
    
    func mostUsedMessages(limit: Int) -> [Message] {
        Array(allMessagesResult()
                .sorted(byKeyPath: #keyPath(Message.numberOfUse), ascending: false)
                .toArray()
                .prefix(limit))
    }
}

extension RealmService {
    func getCategoriesResult(parentCategory: Category?) -> Results<Category> {
        if let parentCategory = parentCategory {
            return getSubCategoriesResult(category: parentCategory)
        } else {
            return all(Category.self).filter("\(#keyPath(Category.parentCategory)) == nil")
        }
    }
    
    func getSubCategoriesResult(category: Category) -> Results<Category> {
        all(Category.self)
            .filter("\(#keyPath(Category.parentCategory)) == %@", category)
    }
    
    func mostUsedCategories(limit: Int) -> [Category] {
        Array(getCategoriesResult(parentCategory: nil)
            .toArray()
            .sorted(by: { lhs, rhs in
                return lhs.numberOfUse < rhs.numberOfUse
            }).prefix(limit))
    }
}
