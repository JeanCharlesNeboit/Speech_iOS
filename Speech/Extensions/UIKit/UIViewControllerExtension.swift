//
//  UIViewControllerExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import TinyConstraints
import SwiftMessages

extension UIViewController {
    static var main: UIViewController {
        let homeViewController = NavigationController(rootViewController: EditorAreaViewController())
        if UIDevice.current.userInterfaceIdiom == .pad {
            let splitViewController = SplitViewController()
            let mainViewController = NavigationController(rootViewController: MessageListViewController())
            let detailsViewController = homeViewController
            splitViewController.configure(main: mainViewController, details: detailsViewController)
            return splitViewController
        } else {
            return homeViewController
        }
    }
}

extension AbstractViewController {
    func showError(title: String, message: String) {
        showMessageCardView(title: title, body: message, theme: .error)
    }
    
    func showWarning(title: String, message: String) {
        showMessageCardView(title: title, body: message, theme: .warning, presentationStyle: .top)
    }
    
    func showSuccess(title: String, message: String) {
        showMessageCardView(title: title, body: message, theme: .success, presentationStyle: .top)
    }
    
    private func showMessageCardView(title: String,
                                     body: String,
                                     layout: MessageView.Layout = .cardView,
                                     theme: Theme,
                                     duration: SwiftMessages.Duration = .seconds(seconds: 2),
                                     presentationStyle: SwiftMessages.PresentationStyle = .bottom) {
        let cardView = MessageView.viewFromNib(layout: .cardView)
        cardView.configureTheme(theme)
        cardView.configureDropShadow()
        cardView.configureContent(title: title, body: body)
        cardView.button?.isHidden = true
        
        var config = SwiftMessages.defaultConfig
        config.keyboardTrackingView = KeyboardTrackingView()
        config.duration = duration
        config.presentationStyle = presentationStyle
        config.presentationContext = .window(windowLevel: .statusBar)
        
        SwiftMessages.show(config: config, view: cardView)
    }
}

extension UIViewController {
    @discardableResult
    func customPresent(_ vc: UIViewController) -> SwiftMessagesSegue {
        let segue = SwiftMessagesSegue(identifier: nil, source: self, destination: vc)
        segue.interactiveHide = false
        segue.presentationStyle = .center
        segue.dimMode = .blur(style: .regular, alpha: 1, interactive: true)
        segue.containerView.cornerRadius = 20
        segue.messageView.configureDropShadow()
        segue.containment = .background
        segue.perform()
        return segue
    }
}
