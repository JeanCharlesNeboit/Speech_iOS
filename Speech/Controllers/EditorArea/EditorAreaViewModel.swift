//
//  EditorAreaViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 28/07/2021.
//

import Foundation
import AVFoundation

class EditorAreaViewModel: AbstractViewModel {
    // MARK: - Enum
    enum ViewModelError: Error {
        case empty
        case duplication
        
        var title: String {
            switch self {
            case .empty:
                return SwiftyAssets.Strings.editor_area_empty_text_on_save_title
            case .duplication:
                return SwiftyAssets.Strings.editor_area_duplication_title
            }
        }
        
        var body: String {
            switch self {
            case .empty:
                return SwiftyAssets.Strings.editor_area_empty_text_on_save_body
            case .duplication:
                return SwiftyAssets.Strings.editor_area_duplication_body
            }
        }
    }
    
    // MARK: - Properties
    @RxBehaviorSubject var text: String?
    
    private lazy var speechSynthesizerService = SpeechSynthesizerService.shared
    
    // MARK: - Initialization
    override init() {
        super.init()
        
        if environmentService.isDev() && !environmentService.isTest() {
            text = "Bonjour"
        }
        
        NotificationCenter.default.rx
            .notification(.editorAreaClearText)
            .subscribe(onNext: { [weak self] _ in
                self?.text = nil
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.editorAreaAppendText)
            .subscribe(onNext: { [weak self] notification in
                guard let self = self,
                      let message = notification.object as? Message else { return }
                message.incrementNumberOfUse()
                
                if DefaultsStorage.replaceTextWhenMessageSelected {
                    self.text = message.text
                } else {
                    self.text = self.text.strongValue + " \(message.text)"
                }
                
            }).disposed(by: disposeBag)
    }
    
    // MARK: -
    private func doesMessageAlreadyExist() -> Bool {
        realmService.doesMessageAlreadyExist(text: text.strongValue)
    }
    
    func onSave() -> Result<String, ViewModelError> {
        guard let text = text.nilIfEmpty else { return .failure(.empty) }
        guard !doesMessageAlreadyExist() else { return .failure(.duplication) }
        return .success(text)
    }
    
    func saveQuickly(onCompletion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let text = text else { return }
        realmService.addObject(Message(text: text), completion: { result in
            onCompletion(result)
        })
    }
    
    func startSpeaking(keyboardLanguage: String?, onCompletion: @escaping ((Result<Void, ViewModelError>) -> Void)) {
        guard let text = text.nilIfEmpty else {
            onCompletion(.failure(.empty))
            return
        }
        
        var voice: AVSpeechSynthesisVoice?
        if DefaultsStorage.useKeyboardLanguageAsVoiceLanguage {
            voice = AVSpeechSynthesisVoice(language: keyboardLanguage)
        }
        speechSynthesizerService.startSpeaking(text: text, voice: voice)
    }
}
