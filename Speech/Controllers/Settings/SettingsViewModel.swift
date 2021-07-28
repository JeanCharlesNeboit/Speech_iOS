//
//  SettingsViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/07/2021.
//

import Foundation

class SettingsViewModel: AbstractViewModel {
    // MARK: - Properties
    let appStoreAppLink = "https://apps.apple.com/app/idXXXXXXXXXX?action=write-review"
    let githubRepositoryLink = "https://github.com/JeanCharlesNeboit/Speech_iOS"
    let appVersionInfo = "\(Bundle.main.info)\n\(SwiftyAssets.Strings.settings_made_in_auvergne)"
}
