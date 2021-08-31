//
//  MessageViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 28/07/2021.
//

import Foundation

class MessageViewModel: AbstractViewModel {
    enum Mode {
        case creation(text: String)
        case edition(message: Message)
        
        var title: String {
            switch self {
            case .creation:
                return SwiftyAssets.Strings.message_new_title
            case .edition:
                return SwiftyAssets.Strings.message_edit_title
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
    let mode: Mode
    @RxBehaviorSubject var emoji: String?
    @RxBehaviorSubject var message: String?
    @RxBehaviorSubject var category: Category?
    
    // MARK: - Initialization
    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .creation(let text):
            self.message = text
        case .edition(let message):
            self.emoji = message.emoji
            self.message = message.text
            self.category = message.category
        }
    }
    
    // MARK: -
    func onValidate(onCompletion: ((Result<Void, Error>) -> Void)) {
        guard !message.isEmptyOrNil else { return }
        let trimmedMessage = message.strongValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch mode {
        case .creation:
            let message = Message(emoji: emoji,
                                  text: trimmedMessage,
                                  category: category)
            realmService.addObject(message)
        case .edition(let message):
            realmService.write {
                message.emoji = emoji
                message.text = trimmedMessage
                message.category = category
            }
        }
        
        onCompletion(.success(()))
    }
}
