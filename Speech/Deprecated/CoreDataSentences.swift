//
//  Sentences+CoreDataProperties.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 15/07/2017.
//  Copyright © 2017 Jean-Charles Neboit. All rights reserved.
//
//

import Foundation
import CoreData

class Sentences: NSManagedObject {
    // MARK: - Properties
    @NSManaged public var text: String!
    
    // MARK: - FetchRequest
    @nonobjc public class func sentencesFetchRequest() -> NSFetchRequest<Sentences> {
        return NSFetchRequest<Sentences>(entityName: "Sentences")
    }
}
