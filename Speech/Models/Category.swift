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
    @objc private(set) dynamic var name: String = ""
    @objc private(set) dynamic var parentCategory: Category?
    private(set) var subCategories = List<Category>()
    
    // MARK: - Initialization
    convenience init(parentCategory: Category?, name: String) {
        self.init()
        self.name = name
        self.parentCategory = parentCategory
    }
    
    // MARK: - Object
    override class func primaryKey() -> String? {
        #keyPath(Category.name)
    }
}

extension Category: Comparable {
    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.name.diacriticInsensitive < rhs.name.diacriticInsensitive
    }
}
