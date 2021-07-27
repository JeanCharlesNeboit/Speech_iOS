//
//  RealmExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import Foundation
import Realm
import RealmSwift

extension Realm {
    func printFilePath() {
        guard let path = configuration.fileURL?.path else { return }
        NSLog("📁 Realm Path: \(path)")
    }
    
    func deleteCascade(_ entity: RLMObjectBase) {
        guard let entity = entity as? Object else { return }
        var toBeDeleted = Set<RLMObjectBase>()
        toBeDeleted.insert(entity)
        while !toBeDeleted.isEmpty {
            guard let element = toBeDeleted.removeFirst() as? Object,
                  !element.isInvalidated else { continue }
            resolve(element: element, toBeDeleted: &toBeDeleted)
        }
    }
    
    private func resolve(element: Object, toBeDeleted: inout Set<RLMObjectBase>) {
        element.objectSchema.properties.forEach {
            guard let value = element.value(forKey: $0.name) else { return }
            if let entity = value as? RLMObjectBase {
                toBeDeleted.insert(entity)
            } else if let list = value as? RLMSwiftCollectionBase {
                for index in 0..<list._rlmCollection.count {
                    if let object = list._rlmCollection.object(at: index) as? RLMObjectBase {
                        toBeDeleted.insert(object)
                    }
                }
            }
        }
        delete(element)
    }
}
