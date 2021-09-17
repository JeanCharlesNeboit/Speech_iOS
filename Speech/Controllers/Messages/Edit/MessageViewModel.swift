//
//  MessageViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 28/07/2021.
//

import Foundation

protocol MessageViewModelProtocol: AbstractViewModel {
    
}

extension MessageViewModelProtocol {
    func canMessageBeSaved(text: String?) -> Result<String, MessageError> {
        guard let text = text.nilIfEmpty else {
            return .failure(MessageError.empty)
        }
        guard !realmService.doesMessageAlreadyExist(text: text) else {
            return .failure(MessageError.duplication)
        }
        return .success(text)
    }
}

class MessageViewModel: AbstractViewModel, MessageViewModelProtocol {
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
    func onValidate(onCompletion: @escaping ((Result<Void, Error>) -> Void)) {
        guard !message.isEmptyOrNil else { return }
        let trimmedMessage = message.strongValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch mode {
        case .creation:
            #warning("Show error in controller & check id to avoid duplication by editing")
            if case .failure(let error) = canMessageBeSaved(text: trimmedMessage) {
                onCompletion(.failure(error))
                return
            }
            
            let message = Message(emoji: emoji,
                                  text: trimmedMessage,
                                  category: category)
            realmService.save(message: message, completion: onCompletion)
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
