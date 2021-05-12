//
//  VoiceListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 14/04/2021.
//

import UIKit
import AVFoundation

class VoiceListViewController: BaseListViewController {
    // MARK: - Properties
    private var voicesGroupedByLocales: [Locale: [AVSpeechSynthesisVoice]] {
        Dictionary(grouping: AVSpeechSynthesisVoice.speechVoices(), by: { Locale(identifier: $0.language) })
//            .filter {
//                $0.language == Bundle.main.preferredLocalizations.first
//            }
    }
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.preferences_voice
        sections = voicesGroupedByLocales.map { locale, voices in
            let country = [locale.countryFlag, locale.countryName].compactMap { $0 }.joined(separator: " ")
            return Section(model: .init(header: country),
                    items: voices.map { voice in
                        var genderEmoji: String?
                        if #available(iOS 13.0, *) {
                            switch voice.gender {
                            case .unspecified:
                                break
                            case .male:
                                genderEmoji = "🧔"
                            case .female:
                                genderEmoji = "👩"
                            @unknown default:
                                break
                            }
                        }
                        let voice = [genderEmoji, voice.name].compactMap { $0 }.joined(separator: " ")
                        return .details(title: voice, vc: UIViewController())
                    })
                }
        sections.insert(Section(model: .init(header: "To use more voice, download more on your device settings*"),
                                items: []), at: 0)
    }
}
