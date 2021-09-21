//
//  NewCategoryViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/07/2021.
//

import Foundation

class CategoryViewModel: AbstractViewModel {
    enum Mode {
        case creation(parentCategory: Category?)
        case edition(category: Category)
        
        var title: String {
            switch self {
            case .creation:
                return SwiftyAssets.Strings.category_new_title
            case .edition:
                return SwiftyAssets.Strings.category_edit_title
            }
        }
        
        var saveTitle: String {
            switch self {
            case .creation:
                return SwiftyAssets.Strings.generic_create
            case .edition:
                return SwiftyAssets.Strings.generic_edit
            }
        }
    }
    
    // MARK: - Properties
    @RxBehaviorSubject var emoji: String?
    @RxBehaviorSubject var name: String?
    
    let mode: Mode
    
    // MARK: - Initialization
    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .creation:
            break
        case .edition(let category):
            self.emoji = category.emoji
            self.name = category.name
        }
    }
    
    // MARK: -
    #warning("ToDo")
    func canMessageBeSaved(name: String?) -> Result<String, MessageError> {
        guard let name = name.nilIfEmpty else {
            return .failure(MessageError.empty)
        }
        guard !realmService.doesCategoryAlreadyExist(name: name) else {
            return .failure(MessageError.duplication)
        }
        return .success(name)
    }
    
    func onValidate(onCompletion: ((Result<Void, SpeechError>) -> Void)) {
        guard !name.isEmptyOrNil else { return }
        let trimmedName = name.strongValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch mode {
        case .creation(let parentCategory):
            if case .failure(let error) = canMessageBeSaved(name: trimmedName) {
                onCompletion(.failure(.localized(error)))
                return
            }
            
            let category = Category(name: name.strongValue,
                                    emoji: emoji,
                                    parentCategory: parentCategory)
            realmService.addObject(category)
        case .edition(let category):
            #warning("Check for subcategories")
            if case .failure(let error) = canMessageBeSaved(name: trimmedName) {
                if error == MessageError.duplication,
                   let categoryId = realmService.getCategory(name: trimmedName)?.id,
                   categoryId == category.id {
                    // Allow
                } else {
                    onCompletion(.failure(.localized(error)))
                    return
                }
            }
            
            realmService.write {
                category.name = name.strongValue
                category.emoji = emoji
            }
        }
        onCompletion(.success(()))
    }
}
