//
//  EditorAreaViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 28/07/2021.
//

import Foundation
import AVFoundation

class EditorAreaViewModel: AbstractViewModel, MessageViewModelProtocol {
    // MARK: - Properties
    @RxBehaviorSubject var text: String?
    
    private lazy var speechSynthesizerService = SpeechSynthesizerService.shared
    
    // MARK: - Initialization
    override init() {
        super.init()
        
        if environmentService.isDebug && !environmentService.isTest && false {
            text = "Bonjour"
        }
        
        NotificationCenter.default.rx
            .notification(.EditorAreaClearText)
            .subscribe(onNext: { [weak self] _ in
                self?.text = nil
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.EditorAreaAppendText)
            .subscribe(onNext: { [weak self] notification in
                guard let self = self,
                      let message = notification.object as? Message else { return }
                message.incrementNumberOfUse()
                
                if DefaultsStorage.replaceTextWhenMessageSelected || self.text.isEmptyOrNil {
                    self.text = message.text
                } else {
                    self.text = self.text.strongValue + " \(message.text)"
                }
                
            }).disposed(by: disposeBag)
    }
    
    // MARK: -
    func saveQuickly(onCompletion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let text = text else { return }
        let message = Message(text: text)
        realmService.save(message: message, completion: onCompletion)
    }
    
    func startSpeaking(keyboardLanguage: String?, onCompletion: @escaping ((Result<Void, SpeechError>) -> Void)) {
        guard let text = text.nilIfEmpty else {
            onCompletion(.failure(.localized(MessageError.empty)))
            return
        }
        
        var voice: AVSpeechSynthesisVoice?
        if DefaultsStorage.useKeyboardLanguageAsVoiceLanguage {
            voice = AVSpeechSynthesisVoice(language: keyboardLanguage)
        }
        speechSynthesizerService.startSpeaking(text: text, voice: voice)
    }
}
