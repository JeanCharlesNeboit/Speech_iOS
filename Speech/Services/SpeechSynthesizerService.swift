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
    private lazy var speechSynthesizer = AVSpeechSynthesizer()
    let state = BehaviorSubject<SpeechSynthesizerState>(value: .idle)
    
    // MARK: - Initialization
    private override init() {
        
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
}

extension SpeechSynthesizerService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        state.onNext(.speak)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        state.onNext(.speak)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        state.onNext(.pause)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        state.onNext(.idle)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        state.onNext(.idle)
    }
}
