//
//  VoiceListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 14/04/2021.
//

import UIKit
import AVFoundation

class VoiceListViewController: BaseListViewController {
    // MARK: - Struct
    struct VoicesSection {
        let locale: Locale
        let voices: [AVSpeechSynthesisVoice]
    }
    
    // MARK: - Properties
    private var voicesSections: [VoicesSection] {
        [
            Dictionary(grouping: AVSpeechSynthesisVoice.speechVoices(), by: { Locale(identifier: $0.language) })
                .map { VoicesSection(locale: $0.key, voices: $0.value) }
                .sorted { lhs, rhs in
                    lhs.locale.countryName.strongValue < rhs.locale.countryName.strongValue
                }.first { $0.locale.identifier == DefaultsStorage.preferredLanguage }
        ].compactMap { $0 }
    }
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.preferences_voice
        
        DefaultsStorage.$preferredVoices.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.sections = self.voicesSections.map { section in
                let country = [section.locale.countryFlag, section.locale.countryName].compactMap { $0 }.joined(separator: " ")
                let preferredVoice = DefaultsStorage.preferredVoice
                
                return Section(model: .init(header: country),
                               items: section.voices.map { voice in
                                var genderEmoji: String?
                                if #available(iOS 13.0, *) {
                                    genderEmoji = voice.gender.emoji
                                }
                                let voiceName = [genderEmoji, voice.name].compactMap { $0 }.joined(separator: " ")
                                return .selection(config: .init(title: voiceName), isSelected: voice.identifier == preferredVoice, onTap: {
                                    guard let preferredLanguage = DefaultsStorage.preferredLanguage else { return }
                                    DefaultsStorage.preferredVoices[preferredLanguage] = voice.identifier
                                })
                               })
            }
            
            self.sections.insert(Section(model: .init(header: SwiftyAssets.Strings.preferences_voice_get_more),
                                    items: []), at: 0)
        }).disposed(by: disposeBag)
    }
    
    private func update() {
        
    }
}
