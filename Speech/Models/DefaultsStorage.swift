//
//  DefaultsStorage.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 07/04/2021.
//

import SwiftyKit

class DefaultsStorage {
    @SwiftyUserDefaults(key: UserDefaultsKeys.welcomeDone(), defaultValue: false)
    static var welcomeDone: Bool
    
    @SwiftyRawUserDefaults(key: UserDefaultsKeys.preferredMessagesSortMode(), defaultValue: .alphabetical)
    static var preferredSortMode: SortMode
}
