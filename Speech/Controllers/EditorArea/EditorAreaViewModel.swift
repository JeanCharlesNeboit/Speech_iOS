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
        
        NotificationCenter.default.rx
            .notification(.editorAreaClearText)
            .subscribe(onNext: { [weak self] _ in
                self?.text = nil
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.editorAreaAppendText)
            .subscribe(onNext: { [weak self] notification in
                guard let text = notification.object as? String else { return }
                self?.text = text
            }).disposed(by: disposeBag)
    }
    
    func startSpeaking() {
        // let language = textView.textInputMode?.primaryLanguage
        speechSynthesizerService.startSpeaking(text: text.strongValue, voice: nil)
    }
}
