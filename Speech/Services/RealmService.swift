//
//  RealmService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import Foundation
import SwiftyKit
import RealmSwift

enum WriteResult {
    case success
    case failure
}

class RealmService {
    // MARK: - Singleton
    static let `default` = RealmService()
    
    // MARK: - Properties
    private let realm: Realm
    
    // MARK: - Initialization
    init() {
        do {
            realm = try Realm()
        } catch let error {
            NSLog("Failed to instanciate database: \(error.localizedDescription)")
            fatalError()
        }
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
        do {
            try commitWrite()
            completion?(.success)
        } catch let error {
            NSLog("❌ Transaction could not be written. (\(error.localizedDescription))")
            completion?(.failure)
        }
    }
    
//    func write(block: () -> Void) throws {
//        try realm.write(block)
//    }
    
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
    
    func deleteObject<T: Object>(_ object: T, completion: ((WriteResult) -> Void)? = nil) {
        beginWrite()
        realm.deleteCascade(object)
//        realm.delete(object)
        commit(completion: completion)
    }
}

extension RealmService {
    func allMessagesResult() -> Results<Message> {
        all(Message.self)
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
            return all(Category.self).filter("parentCategory == nil")
        }
    }
    
    func getSubCategoriesResult(category: Category) -> Results<Category> {
        all(Category.self)
            .filter("parentCategory == %@", category)
    }
}
