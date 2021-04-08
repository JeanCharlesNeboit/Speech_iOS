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

class SettingsViewController: BaseSettingsViewController {
    // MARK: - Properties
    private var widthConstraint: NSLayoutConstraint?
    
    private static var SettingsSections: [Section] {
        [
            Section(model: .init(),
                    items: [
                        .details(vc: BaseSettingsViewController(title: SwiftyAssets.Strings.settings_appearance, sections: [])),
                        .details(vc: BaseSettingsViewController(title: SwiftyAssets.Strings.settings_voice, sections: [])),
                        .details(vc: CategoriesViewController())
                    ]),
            Section(model: .init(footer: "\(Bundle.main.info)\n\(SwiftyAssets.Strings.settings_made_in_auvergne)"),
                    items: [
                        .details(vc: AboutViewController()),
                        .details(title: SwiftyAssets.Strings.settings_open_source, vc: BaseSettingsViewController(title: "Open Source*", sections: [])),
                        .details(vc: BaseSettingsViewController(title: SwiftyAssets.Strings.settings_thanks, sections: []))
                    ])
        ]
    }
    
//    public override var preferredContentSize: CGSize {
//        get {
//            let screenBounds = UIScreen.main.bounds
//            return CGSize(width: screenBounds.width * 0.5, height: screenBounds.height * 0.6)
//        }
//
//        set { super.preferredContentSize = newValue }
//    }
    
    // MARK: - Initialization
    init() {
        super.init(title: SwiftyAssets.Strings.generic_settings, sections: Self.SettingsSections)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func configure() {
        super.configure()
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
}
