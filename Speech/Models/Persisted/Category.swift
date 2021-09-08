//
//  Category.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import Foundation
import RealmSwift

class Category: Object {
    // MARK: - Properties
    @Persisted(primaryKey: true) private var id: String
    @Persisted var name: String
    @Persisted var emoji: String?
    @objc @Persisted private(set) var parentCategory: Category?
    
    var nameWithEmoji: String {
        [emoji, name]
            .compactMap { $0 }
            .joined(separator: " ")
    }
    
    var subCategories: [Category] {
        RealmService.default.getSubCategoriesResult(category: self).toArray()
    }
    
    var messages: [Message] {
        RealmService.default.allMessagesResult(category: self).toArray()
    }
    
    @objc var numberOfUse: Int {
        #warning("average could be better condition")
        return messages.compactMap { $0.numberOfUse }.reduce(0, +)
    }
    
    // MARK: - Initialization
    convenience init(name: String,
                     emoji: String?,
                     parentCategory: Category?) {
        self.init()
        self.id = UUID().uuidString
        self.name = name
        self.emoji = emoji
        self.parentCategory = parentCategory
    }
}

extension Category: Searchable {
    var searchText: String {
        name
    }
}

extension Category: Comparable {
    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.name.diacriticInsensitive < rhs.name.diacriticInsensitive
    }
}

class WithoutCategory: Category {
    // MARK: - Initialization
    override init() {
        super.init()
        name = SwiftyAssets.Strings.category_without_category
        emoji = "📁"
    }
    
    // MARK: - Properties
    override var messages: [Message] {
        RealmService.default.allMessagesResult(category: nil).toArray()
    }
}
