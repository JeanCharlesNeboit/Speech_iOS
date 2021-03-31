//
//  RealmService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import Foundation
import SwiftyKit
import RealmSwift

public class RealmService {
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
    
    // MARK: - Request
    func object<T>(ofType type: T.Type) -> Results<T> where T: RealmSwift.Object {
        return realm.objects(type)
    }
    
    func addObject<T: Object>(_ object: T) {
        addObjects([object])
    }
    
    func addObjects<T: Object>(_ objects: [T]) {
        beginWrite()
        realm.add(objects, update: .all)
        do {
            try commitWrite()
        } catch let error {
            NSLog("❌ Transaction could not be written. (\(error.localizedDescription))")
        }
        
    }
}

extension RealmService {
    func getMessagesResult() -> Results<Message> {
        return object(ofType: Message.self)
    }
}
