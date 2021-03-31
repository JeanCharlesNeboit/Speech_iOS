//
//  UIViewExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit

extension UIViewController {
    static var main: UISplitViewController {
        let splitViewController = UISplitViewController()
        splitViewController.preferredDisplayMode = .oneBesideSecondary
        splitViewController.viewControllers = [
            NavigationController(rootViewController: MessageListViewController()),
            NavigationController(rootViewController: EditorAreaViewController())
        ]
        return splitViewController
    }
}
