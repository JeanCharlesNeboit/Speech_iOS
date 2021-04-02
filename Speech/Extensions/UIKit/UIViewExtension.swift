//
//  UIViewControllerExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
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

extension UIViewController {
    func customPresent(_ vc: UIViewController) {
        let segue = SwiftMessagesSegue(identifier: nil, source: self, destination: vc)
        segue.interactiveHide = false
        segue.presentationStyle = .center
        segue.dimMode = .blur(style: .light, alpha: 0.5, interactive: true)
        segue.containerView.cornerRadius = 20
//        segue.messageView.collapseLayoutMarginAdditions = true
        segue.containment = .background
        segue.perform()
    }
}
