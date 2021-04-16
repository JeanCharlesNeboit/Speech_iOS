//
//  SettingsViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/03/2021.
//

import UIKit
import SwiftyKit
import RxSwift
import RxDataSources
import SwiftMessages

class SettingsViewController: BaseListViewController {
    // MARK: - Properties
    private static var SettingsSections: [Section] {
        [
            Section(model: .init(),
                    items: [
                        .details(vc: AppearanceListViewController()),
                        .details(vc: SpeechSynthesisListViewController()),
                        .details(vc: CategoriesListViewController())
                    ]),
            Section(model: .init(footer: "\(Bundle.main.info)\n\(SwiftyAssets.Strings.settings_made_in_auvergne)"),
                    items: [
                        .details(vc: AboutViewController()),
                        .link(title: SwiftyAssets.Strings.settings_github, urlString: "https://github.com/JeanCharlesNeboit/Speech_iOS"),
                        .details(vc: OpenSourceListViewController()),
                        .details(vc: ThanksListViewController())
                    ])
        ]
    }
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.generic_settings
        sections = Self.SettingsSections
    }
    
    // MARK: - Lifecycle
    override func configure() {
        super.configure()
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
}
