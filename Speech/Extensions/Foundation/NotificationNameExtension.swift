//
//  NotificationNameExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/03/2021.
//

import Foundation
 
extension Notification.Name {
    // MARK: - Editor
    static let EditorAreaClearText = Notification.Name("EditorAreaClearText")
    static let EditorAreaSaveText = Notification.Name("EditorAreaSaveText")
    static let EditorAreaAppendText = Notification.Name("EditorAreaAppendText")
    static let EditorAreaStartSpeaking = Notification.Name("EditorAreaStartSpeaking")
    static let EditorAreaContinueSpeaking = Notification.Name("EditorAreaContinueSpeaking")
    static let EditorAreaPauseSpeaking = Notification.Name("EditorAreaPauseSpeaking")
    static let EditorAreaStopSpeaking = Notification.Name("EditorAreaStopSpeaking")
    
    // MARK: - Message
    static let MessageDidSave = Notification.Name("MessageDidSave")
}
