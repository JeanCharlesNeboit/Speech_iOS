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
    @SwiftyUserDefaults(key: UserDefaultsKeys.welcomeDone(), defaultValue: false)
    static var welcomeDone: Bool
    
    // Editor area
    @SwiftyRawUserDefaults(key: UserDefaultsKeys.preferredEditorAreaTextFont(), defaultValue: .body)
    static var preferredEditorAreaTextFont: FontStyle {
        didSet {
            preferredEditorAreaTextFontSubject.onNext(preferredEditorAreaTextFont)
        }
    }
    static var preferredEditorAreaTextFontSubject = BehaviorSubject<FontStyle>(value: preferredEditorAreaTextFont)
    
    // Messages
    @SwiftyRawUserDefaults(key: UserDefaultsKeys.preferredMessagesSortMode(), defaultValue: .alphabetical)
    static var preferredSortMode: SortMode
    
    @SwiftyUserDefaults(key: UserDefaultsKeys.showFrequentlyUsedMessages(), defaultValue: false)
    static var showFrequentlyUsedMessages: Bool {
        didSet {
            showFrequentlyUsedMessagesSubject.onNext(showFrequentlyUsedMessages)
        }
    }
    static var showFrequentlyUsedMessagesSubject = BehaviorSubject<Bool>(value: showFrequentlyUsedMessages)
}
