//
//  NotificationNameExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/03/2021.
//

import Foundation
 
extension Notification.Name {
    static let editorAreaClearText = Notification.Name("editorAreaClearText")
    static let editorAreaSaveText = Notification.Name("editorAreaSaveText")
    static let editorAreaAppendText = Notification.Name("editorAreaAppendText")
    static let editorAreaStartSpeaking = Notification.Name("editorAreaStartSpeaking")
}
