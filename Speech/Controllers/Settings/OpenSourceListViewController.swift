//
//  OpenSourceListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

class OpenSourceListViewController: BaseListViewController {
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.settings_open_source
        sections = [
            Section(model: .init(), items: [
                .link(title: "Firebase", urlString: "https://github.com/firebase/firebase-ios-sdk.git"),
                .link(title: "Realm", urlString: "https://github.com/realm/realm-cocoa.git"),
                .link(title: "RxSwift", urlString: "https://github.com/ReactiveX/RxSwift.git"),
                .link(title: "RxDataSources", urlString: "https://github.com/RxSwiftCommunity/RxDataSources.git"),
                .link(title: "RxKeyboard", urlString: "https://github.com/RxSwiftCommunity/RxKeyboard.git"),
                .link(title: "SwiftDate", urlString: "https://github.com/malcommac/SwiftDate.git"),
                .link(title: "SwiftMessages", urlString: "https://github.com/SwiftKickMobile/SwiftMessages.git"),
                .link(title: "TinyConstraints", urlString: "https://github.com/roberthein/TinyConstraints.git")
            ])
        ]
    }
}
