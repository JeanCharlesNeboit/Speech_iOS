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
    private(set) var subCategories = List<Category>()
    
    // MARK: - Initialization
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    // MARK: - Object
    override class func primaryKey() -> String? {
        #keyPath(Category.name)
    }
}
