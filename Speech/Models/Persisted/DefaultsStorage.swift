//
//  DefaultsStorage.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 07/04/2021.
//

import SwiftyKit
import RxSwift
import Foundation
import AVFoundation

// swiftlint:disable redundant_optional_initialization
class DefaultsStorage {
    // MARK: - Welcome
    @UserDefault(key: UserDefaultsKeys.welcomeDone())
    static var welcomeDone: Bool = false
    
    // MARK: - Editor area
    @RxRawUserDefault(key: UserDefaultsKeys.preferredEditorAreaTextFont())
    static var preferredEditorAreaTextFont: FontStyle = .body
    
    // MARK: - Speaking
    @UserDefault(key: UserDefaultsKeys.preferredSpeakingRate())
    static var preferredSpeakingRate: Float = 0.5
    
    // MARK: - Voice
    @RxUserDefault(key: UserDefaultsKeys.preferredLanguage())
    static var preferredLanguage: String? = nil
    
    @UserDefault(key: UserDefaultsKeys.automaticLanguageRecognition())
    static var automaticLanguageRecognition: Bool = true
    
    // MARK: - Messages
    @RxUserDefault(key: UserDefaultsKeys.savedMessagesCount())
    static var savedMessagesCount: Int = 0
    
    @RxRawUserDefault(key: UserDefaultsKeys.preferredMessageDisplayMode())
    static var preferredMessageDisplayMode: MessageListViewController.DisplayMode = .list
    
    @RawUserDefault(key: UserDefaultsKeys.preferredMessagesSortMode())
    static var preferredMessageSortMode: SortMode = .alphabetical
    
    @UserDefault(key: UserDefaultsKeys.saveMessagesQuickly())
    static var saveMessagesQuickly: Bool = false
    
    @RxUserDefault(key: UserDefaultsKeys.showFrequentlyUsedMessages())
    static var showFrequentlyUsedMessages: Bool = true
    
    @UserDefault(key: UserDefaultsKeys.saveMessagesQuickly())
    static var replaceTextWhenMessageSelected: Bool = true
    
    @UserDefault(key: UserDefaultsKeys.closeMessageViewWhenMessageSelected())
    static var closeMessageViewWhenMessageSelected: Bool = true
    
    // MARK: - Privacy
    @RxUserDefault(key: UserDefaultsKeys.enableCrashlyticsCollection())
    static var enableCrashlyticsCollection: Bool = false
    
    // MARK: - Configure
    static func configure() {
        #if DEBUG && false
        self.preferredLanguage = nil
        #endif
        
        let isoLanguageCode = [
            Locale.current.languageCode,
            Locale.current.regionCode
        ].compactMap { $0 }
        .joined(separator: "-")
        
        if self.preferredLanguage == nil {
            if let voice = AVSpeechSynthesisVoice.init(language: isoLanguageCode) {
                self.preferredLanguage = voice.language
            } else {
                self.preferredLanguage = "en-US"
            }
        }
    }
}
// swiftlint:enable redundant_optional_initialization
