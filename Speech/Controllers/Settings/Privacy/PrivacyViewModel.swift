//
//  PrivacyViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/09/2021.
//

import Foundation
import SwiftyKit

class PrivacyViewModel: AbstractViewModel {
    // MARK: - Properties
    private let privacyPolicyPrefixName = "PrivacyPolicy/privacy_policy_"
    private lazy var defaultPrivacyPolicyName = "\(privacyPolicyPrefixName)en"
    
    var markdown: String {
        let preferredLanguage = Locale.current.languageCode ?? ""
        let path: String? = [
            getMarkdownFilePath(filename: "\(privacyPolicyPrefixName)\(preferredLanguage)"),
            getMarkdownFilePath(filename: defaultPrivacyPolicyName)
        ].compactMap { $0 }
        .first
        
        guard let path = path else { return "" }
        let content: String? = FileManager.default.contents(atPath: path)
        return content.strongValue
    }
    
    private func getMarkdownFilePath(filename: String) -> String? {
        Bundle.main.path(forResource: filename, ofType: "md")
    }
}
