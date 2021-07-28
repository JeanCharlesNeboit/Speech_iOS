//
//  NewCategoryViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/07/2021.
//

import Foundation

class NewCategoryViewModel: AbstractViewModel {
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
    func onCreate(onCompletion: ((Result<Void, Error>) -> Void)) {
        guard !name.isEmptyOrNil else {
            return
        }
        
        switch mode {
        case .creation(let parentCategory):
            let category = Category(name: name.strongValue,
                                    emoji: emoji,
                                    parentCategory: parentCategory)
            realmService.addObject(category)
        case .edition(let category):
            realmService.write {
                category.name = name.strongValue
                category.emoji = emoji
            }
        }
        onCompletion(.success(()))
    }
}
