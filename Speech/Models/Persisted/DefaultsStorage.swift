//
//  DefaultsStorage.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 07/04/2021.
//

import SwiftyKit
import RxSwift

class DefaultsStorage {
    // Welcome
    @UserDefault(key: UserDefaultsKeys.welcomeDone())
    static var welcomeDone: Bool = false
    
    // Editor area
    @RxRawUserDefault(key: UserDefaultsKeys.preferredEditorAreaTextFont())
    static var preferredEditorAreaTextFont: FontStyle = .body
    
    // Speaking
    @UserDefault(key: UserDefaultsKeys.preferredSpeakingRate())
    static var preferredSpeakingRate: Float = 0.5
    
    // Voice
    @UserDefault(key: UserDefaultsKeys.useKeyboardLanguageAsVoiceLanguage())
    static var useKeyboardLanguageAsVoiceLanguage: Bool = true
    
    // Messages
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
}
