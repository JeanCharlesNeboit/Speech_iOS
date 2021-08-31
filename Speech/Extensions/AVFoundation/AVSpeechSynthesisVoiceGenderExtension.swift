//
//  AVSpeechSynthesisVoiceGenderExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/08/2021.
//

import AVFoundation

@available(iOS 13.0, *)
extension AVSpeechSynthesisVoiceGender {
    var emoji: String? {
        switch self {
        case .unspecified:
            return nil
        case .male:
            return "🧔‍♂️"
        case .female:
            return "👩"
        @unknown default:
            return nil
        }
    }
}
