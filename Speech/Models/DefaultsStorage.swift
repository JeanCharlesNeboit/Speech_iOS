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
    static var preferredSpeakingRate: Float = 0.5
    
    // Messages
    @RawUserDefault(key: UserDefaultsKeys.preferredMessagesSortMode())
    static var preferredSortMode: SortMode = .alphabetical
    
    @RxUserDefault(key: UserDefaultsKeys.showFrequentlyUsedMessages())
    static var showFrequentlyUsedMessages: Bool = false
    
    static var saveMessagesQuickly: Bool = false
}
