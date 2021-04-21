//
//  SpeechSynthesizerService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 31/03/2021.
//

import RxSwift
import AVFoundation

enum SpeechSynthesizerState {
    case idle
    case speak
    case pause
}

class SpeechSynthesizerService: NSObject {
    // MARK: - Properties
    static let shared = SpeechSynthesizerService()
    
    private let disposeBag = DisposeBag()
    private lazy var speechSynthesizer = AVSpeechSynthesizer()
    
    @RxBehaviorSubject var state: SpeechSynthesizerState = .idle
    
    // MARK: - Initialization
    private override init() {
        super.init()
        speechSynthesizer.delegate = self
        listenNotifications()
    }
    
    // MARK: -
    private func listenNotifications() {
        NotificationCenter.default.rx
            .notification(.editorAreaContinueSpeaking)
            .subscribe(onNext: { [self] _ in
                continueSpeaking()
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.editorAreaPauseSpeaking)
            .subscribe(onNext: { [self] _ in
                pauseSpeaking()
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.editorAreaStopSpeaking)
            .subscribe(onNext: { [self] _ in
                stopSpeaking()
            }).disposed(by: disposeBag)
    }
    
    // MARK: -
    func startSpeaking(text: String) {
        let speechUterrance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUterrance)
        
        //         speechUterrance.rate = preferences.rate
        //         let currentKeyboardLanguage = textView.textInputMode?.primaryLanguage
        //        if currentKeyboardLanguage != nil{
        //            speechUterrance.voice = AVSpeechSynthesisVoice(language: currentKeyboardLanguage)
        //        }
        //        let selectedTextRange = textView.selectedTextRange
        //        let selectedText = textView.text(in: selectedTextRange!)
        //        if selectedText != "" {
        //            speechUterrance = AVSpeechUtterance(string: selectedText!)
        //        }
    }
    
    private func continueSpeaking() {
        speechSynthesizer.continueSpeaking()
    }
    
    private func pauseSpeaking() {
        speechSynthesizer.pauseSpeaking(at: .immediate)
    }
    
    private func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}

extension SpeechSynthesizerService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        state = .speak
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        state = .speak
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        state = .pause
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        state = .idle
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        state = .idle
    }
}
