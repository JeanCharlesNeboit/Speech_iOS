//
//  EditorAreaViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 28/07/2021.
//

import Foundation

class EditorAreaViewModel: AbstractViewModel {
    // MARK: - Properties
    @RxBehaviorSubject var text: String?
    
    private lazy var speechSynthesizerService = SpeechSynthesizerService.shared
    
    // MARK: - Initialization
    override init() {
        super.init()
        
        #if DEBUG
        text = "Bonjour"
        #endif
        
        NotificationCenter.default.rx
            .notification(.editorAreaClearText)
            .subscribe(onNext: { [weak self] _ in
                self?.text = nil
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.editorAreaAppendText)
            .subscribe(onNext: { [weak self] notification in
                guard let message = notification.object as? Message else { return }
                message.incrementNumberOfUse()
                self?.text = message.text
            }).disposed(by: disposeBag)
    }
    
    func startSpeaking() {
        // let language = textView.textInputMode?.primaryLanguage
        speechSynthesizerService.startSpeaking(text: text.strongValue, voice: nil)
    }
    
    // MARK: -
    func doesMessageAlreadyExist() -> Bool {
        realmService.doesMessageAlreadyExist(text: text.strongValue)
    }
    
    func onSaveQuickly(onCompletion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let text = text else { return }
        realmService.addObject(Message(text: text), completion: { result in
            onCompletion(result)
        })
    }
}
