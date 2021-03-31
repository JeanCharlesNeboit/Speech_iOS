//
//  Message.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import Foundation
import RealmSwift

class Message: Object {
    // MARK: - Properties
    @objc private(set) dynamic var id: String?
    @objc private(set) dynamic var text: String?
    @objc private(set) dynamic var addedDate: Date?
    
    // MARK: - Initialization
    convenience init(text: String) {
        self.init()
        self.id = UUID().uuidString
        self.text = text
        self.addedDate = Date()
    }
    
    // MARK: - Object
    override class func primaryKey() -> String? {
        #keyPath(Message.id)
    }
}
