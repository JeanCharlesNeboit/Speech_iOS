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
    func onSave(onCompletion: ((Result<Void, Error>) -> Void)) {
        guard !message.isEmptyOrNil else { return }
        
        switch mode {
        case .creation:
            let message = Message(emoji: emoji,
                                  text: message.strongValue,
                                  category: category)
            realmService.addObject(message)
        case .edition(let message):
            realmService.write {
                message.emoji = emoji
                message.text = self.message.strongValue
                message.category = category
            }
        }
        
        onCompletion(.success(()))
    }
}
