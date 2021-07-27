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
    @Persisted(primaryKey: true) private(set) var name: String = ""
    @Persisted private(set) var parentCategory: Category?
    @Persisted private(set) var subCategories = List<Category>()
    
    // MARK: - Initialization
    convenience init(parentCategory: Category?, name: String) {
        self.init()
        self.name = name
        self.parentCategory = parentCategory
    }
}

extension Category: Comparable {
    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.name.diacriticInsensitive < rhs.name.diacriticInsensitive
    }
}
