//
//  UserDefaultsKeys.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 07/04/2021.
//

import Foundation

enum UserDefaultsKeys: String {
    // MARK: - Onboarding
    case onboardingDone
    
    // MARK: - Editor area
    case preferredEditorAreaTextFont
    
    // MARK: - Speaking
    case preferredSpeakingRate
    
    // MARK: - Voice
    case preferredLanguage
    case preferredVoices
    case automaticLanguageRecognition
    
    // MARK: - Messages
    case savedMessagesCount
    case preferredMessageDisplayMode
    case preferredMessagesSortMode
    case showFrequentlyUsedMessages
    case saveMessagesQuickly
    case closeMessageViewWhenMessageSelected
    
    // MARK: - Privacy
    case enableCrashlyticsCollection
    
    // MARK: - CoreData Migration
    case coreDataMigrationDone
}
