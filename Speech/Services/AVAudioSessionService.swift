//
//  AVAudioSessionService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 31/03/2021.
//

import AVFoundation

class AVAudioSessionService {
    // MARK: - Properties
    static let `default` = AVAudioSessionService()
    
    // MARK: -
    func set(category: AVAudioSession.Category, mode: AVAudioSession.Mode) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(category, mode: mode, options: [])
        } catch {
            NSLog("Failed to set audio session category.")
        }
    }
}
