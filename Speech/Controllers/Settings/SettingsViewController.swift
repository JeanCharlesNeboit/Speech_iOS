//
//  SettingsViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/03/2021.
//

import UIKit
import LinkPresentation
import SwiftyKit
import RxSwift
import RxDataSources
import SwiftMessages

class SettingsViewController: BaseListViewController {
    // MARK: - Properties
    private let appStoreAppLink = "https://apps.apple.com/app/idXXXXXXXXXX?action=write-review"
    private let githubRepositoryLink = "https://github.com/JeanCharlesNeboit/Speech_iOS"
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.generic_settings
        sections = [
            Section(model: .init(),
                    items: [
                        .details(vc: PreferencesListViewController()),
                        .details(vc: CategoriesListViewController())
                    ]),
            Section(model: .init(),
                    items: [
                        .action(title: String(format: SwiftyAssets.Strings.settings_share_app, Bundle.main.displayName), onTap: { [weak self] in
                            self?.onShareApp()
                        }),
                        .link(.init(title: String(format: SwiftyAssets.Strings.settings_rate_app, Bundle.main.displayName), urlString: appStoreAppLink))
                    ]),
            Section(model: .init(),
                    items: [
                        .details(vc: MarkdownViewController())
                    ]),
            Section(model: .init(footer: "\(Bundle.main.info)\n\(SwiftyAssets.Strings.settings_made_in_auvergne)"),
                    items: [
                        .details(vc: AboutViewController()),
                        .link(.init(title: SwiftyAssets.Strings.settings_github,
                                    urlString: githubRepositoryLink,
                                    inApp: false)),
                        .details(vc: OpenSourceListViewController()),
                        .details(vc: ThanksListViewController())
                    ])
        ]
    }
    
    // MARK: - Lifecycle
    override func configure() {
        super.configure()
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    // MARK: -
    private func onShareApp() {
        let activityVC = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2, width: 0, height: 0)
        activityVC.popoverPresentationController?.permittedArrowDirections = []
        present(activityVC, animated: true, completion: nil)
    }
}

extension SettingsViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        URL(string: appStoreAppLink)
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        Bundle.main.displayName
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
        SwiftyAssets.UIImages.app_icon
    }
    
    @available(iOS 13.0, *)
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = Bundle.main.displayName
        metadata.originalURL = URL(string: appStoreAppLink)
        metadata.iconProvider = NSItemProvider(object: SwiftyAssets.UIImages.app_icon)
        return metadata
    }
}
