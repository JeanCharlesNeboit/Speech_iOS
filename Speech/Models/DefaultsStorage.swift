//
//  DefaultsStorage.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 07/04/2021.
//

import SwiftyKit

class DefaultsStorage {
    // Welcome
    @SwiftyUserDefaults(key: UserDefaultsKeys.welcomeDone(), defaultValue: false)
    static var welcomeDone: Bool
    
    // Editor area
    @SwiftyRawUserDefaults(key: UserDefaultsKeys.preferredEditorAreaTextFont(), defaultValue: .body)
    static var preferredEditorAreaTextFont: FontStyle
    
    // Messages
    @SwiftyRawUserDefaults(key: UserDefaultsKeys.preferredMessagesSortMode(), defaultValue: .alphabetical)
    static var preferredSortMode: SortMode
    
    @SwiftyUserDefaults(key: UserDefaultsKeys.showMostUsedMessages(), defaultValue: false)
    static var showMostUsedMessages: Bool
}
