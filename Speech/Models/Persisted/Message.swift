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
    @Persisted(primaryKey: true) private(set) var id: String = ""
    @Persisted private(set) var addedDate: Date = Date()
    @objc @Persisted private(set) dynamic var numberOfUse: Int = 0
    
    @Persisted var emoji: String?
    @Persisted var text: String = ""
    @objc @Persisted var category: Category?
    
    // MARK: - Initialization
    convenience init(emoji: String? = nil, text: String, category: Category? = nil) {
        self.init()
        self.id = UUID().uuidString
        self.emoji = emoji
        self.text = text
        self.category = category
    }
    
    // MARK: -
    func incrementNumberOfUse() {
        try? realm?.write {
            numberOfUse += 1
        }
    }
}

extension Message: Sortable {
    var searchText: String {
        text
    }
}
