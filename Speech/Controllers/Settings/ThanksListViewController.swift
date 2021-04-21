//
//  ThanksListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

class ThanksListViewController: BaseListViewController {
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.settings_thanks
        sections = [
            Section(model: .init(), items: [
                .link(.init(title: "Freepik Storyset*", urlString: "https://storyset.com")),
                .link(.init(title: "Association ADOL43*", urlString: ""))
            ])
        ]
    }
}
