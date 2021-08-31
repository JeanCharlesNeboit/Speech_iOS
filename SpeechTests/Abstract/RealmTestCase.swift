//
//  RealmTestCase.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 31/08/2021.
//

import XCTest
import RealmSwift
@testable import Speech

class RealmTestCase: AbstractXCTestCase {
    // MARK: - Properties
    private(set) lazy var realmService: RealmService! = RealmService.default
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = NSUUID().uuidString
        
        do {
            let realm = try Realm()
            RealmService.default = RealmService(realm: realm)
        } catch let error as NSError {
            fatalError("Unable to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        realmService = nil
    }
}
