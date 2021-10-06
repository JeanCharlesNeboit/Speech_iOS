//
//  PrivacyViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/09/2021.
//

import UIKit

class PrivacyViewController: BaseListViewController {
    // MARK: - Properties
    static let title = SwiftyAssets.Strings.privacy
    private lazy var viewModel = PrivacyViewModel()
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = Self.title
    }
    
    override func configure() {
        super.configure()
        
        sections = [
            Section(model: .init(),
                    items: [
                        .details(config: .init(title: SwiftyAssets.Strings.privacy_policy)) { [unowned self] in
                            MarkdownViewController(markdown: self.viewModel.markdown)
                        },
                        .switchChoice(
                            .init(title: SwiftyAssets.Strings.enable_crashlytics,
                                  initialValue: DefaultsStorage.enableCrashlyticsCollection,
                                  onSwitch: { value in
                                      DefaultsStorage.enableCrashlyticsCollection = value
                                  })
                        )
                    ])
        ]
    }
}
