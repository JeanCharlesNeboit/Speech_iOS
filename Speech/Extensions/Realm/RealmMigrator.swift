//
//  RealmMigrator.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import Foundation
import RealmSwift

class RealmMigrator {
    static let currentSchemaVersion: UInt64 = 4
    
    static private func migrationBlock(migration: Migration, oldSchemaVersion: UInt64) {
        if oldSchemaVersion < 1 {
            NSLog("Migrating realm from schema version \(oldSchemaVersion) to schema version \(currentSchemaVersion)")
        }
    }
    
    static func setDefaultConfiguration() {
        let config = Realm.Configuration(schemaVersion: currentSchemaVersion, migrationBlock: migrationBlock)
        Realm.Configuration.defaultConfiguration = config
    }
}
