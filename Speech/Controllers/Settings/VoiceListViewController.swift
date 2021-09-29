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
        
        sections = voicesSections.map { section in
            let country = [section.locale.countryFlag, section.locale.countryName].compactMap { $0 }.joined(separator: " ")
            return Section(model: .init(header: country),
                           items: section.voices.map { voice in
                var genderEmoji: String?
                if #available(iOS 13.0, *) {
                    genderEmoji = voice.gender.emoji
                }
                let voice = [genderEmoji, voice.name].compactMap { $0 }.joined(separator: " ")
                return .selection(config: .init(title: voice), isSelected: false, onTap: {
                })
            })
        }
        sections.insert(Section(model: .init(header: "To use more voice, download more on your device settings*"),
                                items: []), at: 0)
    }
}
