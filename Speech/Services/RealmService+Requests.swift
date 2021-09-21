//
//  RealmService+Requests.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 16/09/2021.
//

import Foundation
import RealmSwift

extension RealmService {    
    func save(message: Message, completion: @escaping ((WriteResult) -> Void)) {
        addObject(message) { result in
            completion(result)
            if case .success = result {
                DefaultsStorage.savedMessagesCount += 1
                NotificationCenter.default.post(name: .MessageDidSave, object: nil)
            }
        }
    }
    
    func getMessagesResult(in category: Category?) -> Results<Message> {
        if let category = category {
            return allMessagesWithCategoryResult(category: category)
        } else {
            return allMessagesResult()
        }
    }
    
    func getMessage(text: String) -> Message? {
        allMessagesResult().first(where: { $0.text == text })
    }
    
    func allMessagesResult() -> Results<Message> {
        all(Message.self)
    }
    
    func allMessagesWithCategoryResult(category: Category) -> Results<Message> {
        if category != Category.withoutCategory {
            return allMessagesResult().filter("\(#keyPath(Message.category)) == %@", category)
        } else {
            return allMessagesWithoutCategoryResult()
        }
    }
    
    func allMessagesWithoutCategoryResult() -> Results<Message> {
        allMessagesResult().filter("\(#keyPath(Message.category)) == nil")
    }
    
    func doesMessageAlreadyExist(text: String) -> Bool {
        return allMessagesResult().contains(where: { $0.text == text.trimmingCharacters(in: .whitespacesAndNewlines) })
    }
    
    func mostUsedMessages(limit: Int) -> [Message] {
        Array(allMessagesResult()
                .sorted(byKeyPath: #keyPath(Message.numberOfUse), ascending: false)
                .toArray()
                .prefix(limit))
    }
}

extension RealmService {
    func allCategoriesResult() -> Results<Category> {
        all(Category.self)
    }
    
    func getCategory(name: String) -> Category? {
        allCategoriesResult().first(where: { $0.name == name })
    }
    
    func getCategories(parent category: Category?) -> Results<Category> {
        if let category = category {
            return getSubCategoriesResult(parent: category)
        } else {
            return getCategoriesWithoutParentResult()
        }
    }
    
    func getCategoriesWithoutParentResult() -> Results<Category> {
        all(Category.self).filter("\(#keyPath(Category.parentCategory)) == nil")
    }
    
    func getSubCategoriesResult(parent category: Category) -> Results<Category> {
        all(Category.self)
            .filter("\(#keyPath(Category.parentCategory)) == %@", category)
    }
    
    func doesCategoryAlreadyExist(name: String) -> Bool {
        return allCategoriesResult().contains(where: { $0.name == name.trimmingCharacters(in: .whitespacesAndNewlines) })
    }
    
    func mostUsedCategories(limit: Int) -> [Category] {
        Array(getCategoriesWithoutParentResult()
            .toArray()
            .sorted(by: { lhs, rhs in
                return lhs.numberOfUse > rhs.numberOfUse
            }).prefix(limit))
    }
}
