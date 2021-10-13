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
            if #available(iOS 14.5, *) {
                return "🧔‍♂️"
            } else {
                return "👨"
            }
        case .female:
            return "👩"
        @unknown default:
            return nil
        }
    }
}
