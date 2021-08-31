//
//  ThanksListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

class ThanksListViewController: BaseListViewController {
    // MARK: - Properties
    static let title = SwiftyAssets.Strings.settings_thanks
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = Self.title
        sections = [
            Section(model: .init(), items: [
                .link(.init(title: "Association ADOL43", urlString: "")),
                .link(.init(title: "Freepik Storyset", urlString: "https://storyset.com"))
            ])
        ]
    }
}
