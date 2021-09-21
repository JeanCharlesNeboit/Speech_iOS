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
    @Persisted(primaryKey: true) private(set) var id: String
    @Persisted var name: String
    @Persisted var emoji: String?
    @Persisted private(set) var addedDate: Date = Date()
    @objc @Persisted private(set) var parentCategory: Category?
    private var isEmptyCategory = false
    
    var nameWithEmoji: String {
        [emoji, name]
            .compactMap { $0 }
            .joined(separator: " ")
    }
    
    var subCategories: [Category] {
        RealmService.default.getSubCategoriesResult(parent: self).toArray()
    }
    
    var messages: [Message] {
        if isEmptyCategory {
            return RealmService.default.allMessagesWithoutCategoryResult().toArray()
        } else {
            return RealmService.default.allMessagesWithCategoryResult(category: self).toArray()
        }
    }
    
    @objc var numberOfUse: Int {
        #warning("average could be better condition")
        return messages.compactMap { $0.numberOfUse }.reduce(0, +)
    }
    
    // MARK: - Initialization
    convenience init(name: String,
                     emoji: String? = nil,
                     parentCategory: Category? = nil,
                     isEmptyCategory: Bool = false) {
        self.init()
        self.id = UUID().uuidString
        self.name = name
        self.emoji = emoji
        self.parentCategory = parentCategory
        self.isEmptyCategory = isEmptyCategory
    }
}

extension Category: Sortable {
    var searchText: String {
        name
    }
}

extension Category: Comparable {
    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.name.diacriticInsensitive < rhs.name.diacriticInsensitive
    }
}

extension Category {
    static let withoutCategory = Category(name: SwiftyAssets.Strings.category_without_category,
                                          emoji: "📁",
                                          parentCategory: nil,
                                          isEmptyCategory: true)
}
