//
//  AVSpeechSynthesisVoiceExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/10/2021.
//

import AVFoundation

extension AVSpeechSynthesisVoice {
    var locale: String? {
        language.components(separatedBy: "-").first
    }
    
    static var preferredVoice: AVSpeechSynthesisVoice? {
        guard let preferredVoice = DefaultsStorage.preferredVoice else {
            return AVSpeechSynthesisVoice(language: DefaultsStorage.preferredLanguage)
        }
        return AVSpeechSynthesisVoice(identifier: preferredVoice)
    }
    
    static func preferredVoice(locale: String) -> AVSpeechSynthesisVoice? {
        guard let preferredVoice = DefaultsStorage.preferredVoices[locale] else {
            return AVSpeechSynthesisVoice(language: locale)
        }
        return AVSpeechSynthesisVoice(identifier: preferredVoice)
    }
}
