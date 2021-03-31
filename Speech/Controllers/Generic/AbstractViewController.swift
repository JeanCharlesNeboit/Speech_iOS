//
//  AbstractViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import RxSwift
import SwiftyKit
import SwiftMessages

class AbstractViewController: UIViewController {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    lazy var realmService = RealmService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Configure
    func configure() {
        
    }
}

extension AbstractViewController {
    func showError(title: String, message: String) {
        showMessageCardView(title: title, body: message, theme: .error)
    }
    
    private func showMessageCardView(title: String, body: String, theme: Theme) {
        let cardView = MessageView.viewFromNib(layout: .cardView)
        cardView.configureTheme(theme)
        cardView.configureDropShadow()
        cardView.configureContent(title: title, body: body)
        cardView.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.duration = .seconds(seconds: 3)
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: .statusBar)
        SwiftMessages.show(config: config, view: cardView)
    }
}
