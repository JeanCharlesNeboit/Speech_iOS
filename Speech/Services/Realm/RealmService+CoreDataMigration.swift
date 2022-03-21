//
//  RealmService+CoreDataMigration.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 12/10/2021.
//

import Foundation
import SwiftyKit

extension RealmService {
    func performCoreDataToRealmMigration() {
        let realmService = RealmService.default
        let fetchRequest = Sentences.sentencesFetchRequest()
        let managedObjectContext = CoreDataService().managedObjectContext
        
        do {
            let savedSentences = try managedObjectContext.fetch(fetchRequest)
            let texts = savedSentences.map { $0.text }.compactMap { $0 }
            let cleanedTexts = Set(texts.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            
            cleanedTexts.forEach { text in
                if !realmService.doesMessageAlreadyExist(text: text) {
                    let message = Message(text: text)
                    realmService.save(message: message)
                    
                }
            }
            
            savedSentences.forEach { sentence in
                managedObjectContext.delete(sentence)
            }
        } catch let error {
            log.error(error)
        }
        
        DefaultsStorage.coreDataMigrationDone = true
    }
}
