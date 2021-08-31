//
//  OpenSourceListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

class OpenSourceListViewController: BaseListViewController {
    // MARK: - Properties
    static let title = SwiftyAssets.Strings.settings_open_source
    private var dependencies: [(title: String, urlString: String)] {
        [
            (title: "Firebase", urlString: "https://github.com/firebase/firebase-ios-sdk.git"),
            (title: "Realm", urlString: "https://github.com/realm/realm-cocoa.git"),
            (title: "RxSwift", urlString: "https://github.com/ReactiveX/RxSwift.git"),
            (title: "RxDataSources", urlString: "https://github.com/RxSwiftCommunity/RxDataSources.git"),
            (title: "RxKeyboard", urlString: "https://github.com/RxSwiftCommunity/RxKeyboard.git"),
            (title: "SwiftDate", urlString: "https://github.com/malcommac/SwiftDate.git"),
            (title: "SwiftMessages", urlString: "https://github.com/SwiftKickMobile/SwiftMessages.git"),
            (title: "TinyConstraints", urlString: "https://github.com/roberthein/TinyConstraints.git")
        ]
    }
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = Self.title
        sections = [
            Section(model: .init(),
                    items: dependencies.map {
                        .link(.init(title: $0.title, urlString: $0.urlString, inApp: false))
                    })
        ]
    }
}
