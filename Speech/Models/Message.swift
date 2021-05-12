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
    @objc private(set) dynamic var id: String = ""
    @objc private(set) dynamic var addedDate: Date = Date()
    @objc private(set) dynamic var numberOfUse: Int = 0
    
    @objc dynamic var emoji: String?
    @objc dynamic var text: String = ""
    @objc dynamic var category: Category?
    
    // MARK: - Initialization
    convenience init(emoji: String?, text: String) {
        self.init()
        self.id = UUID().uuidString
        self.emoji = emoji
        self.text = text
    }
    
    // MARK: - Object
    override class func primaryKey() -> String? {
        #keyPath(Message.id)
    }
    
    // MARK: -
    func incrementNumberOfUse() {
        try? realm?.write {
            numberOfUse += 1
        }
    }
}

extension Collection where Iterator.Element: Message {
    func sortedByAlphabeticalOrder() -> [Message] {
        sorted(by: { lhs, rhs -> Bool in
            lhs.text.diacriticInsensitive < rhs.text.diacriticInsensitive
        })
    }
    
    func sortedByAddedDateOrder() -> [Message] {
        sorted(by: { lhs, rhs -> Bool in
            lhs.addedDate > rhs.addedDate
        })
    }
}
