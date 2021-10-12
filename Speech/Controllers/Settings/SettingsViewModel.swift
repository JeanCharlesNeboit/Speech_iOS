//
//  SettingsViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/07/2021.
//

import Foundation

class SettingsViewModel: AbstractViewModel {
    // MARK: - Properties
    let appStoreAppLink = "https://apps.apple.com/app/id1080624469?action=write-review"
    let githubRepositoryLink = "https://github.com/JeanCharlesNeboit/Speech_iOS"
    
    var appVersionInfo: String {
        [
            "\(Bundle.main.info(release: environmentService.configurationName))",
            "\(SwiftyAssets.Strings.settings_made_in_auvergne)"
        ].joined(separator: "\n")
    }
}
