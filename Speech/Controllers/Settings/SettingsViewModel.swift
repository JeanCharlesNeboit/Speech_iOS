//
//  SettingsViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/07/2021.
//

import Foundation

class SettingsViewModel: AbstractViewModel {
    enum FeedbackType: CaseIterable {
        case feature
        case bug
        case help
        
        var title: String {
            switch self {
            case .feature:
                return SwiftyAssets.Strings.settings_feedback_feature_request
            case .bug:
                return SwiftyAssets.Strings.settings_bug_report
            case .help:
                return SwiftyAssets.Strings.settings_get_help
            }
        }
    }
    
    // MARK: - Properties
    let appStoreAppLink = "https://apps.apple.com/app/id1080624469?action=write-review"
    let githubRepositoryLink = "https://github.com/JeanCharlesNeboit/Speech_iOS"
    let emailAddress = "speech_app@icloud.com"
    
    var appVersionInfo: String {
        [
            "\(Bundle.main.info(release: environmentService.configurationName))",
            "\(SwiftyAssets.Strings.settings_made_in_auvergne)"
        ].joined(separator: "\n")
    }
}
