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
    @Persisted private(set) var parentCategory: Category?
    
    var nameWithEmoji: String {
        [emoji, name]
            .compactMap { $0 }
            .joined(separator: " ")
    }
    
    var subCategories: [Category] {
        RealmService.default.getSubCategoriesResult(category: self).toArray()
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

extension Category: Comparable {
    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.name.diacriticInsensitive < rhs.name.diacriticInsensitive
    }
}
