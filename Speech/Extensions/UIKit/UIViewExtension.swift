//
//  UIViewExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit

extension UIViewController {
    static var main: UIViewController {
        let homeViewController = NavigationController(rootViewController: EditorAreaViewController())
        if UIDevice.current.userInterfaceIdiom == .pad {
            let splitViewController = UISplitViewController()
            splitViewController.preferredDisplayMode = .oneBesideSecondary
//            splitViewController.maximumPrimaryColumnWidth = splitViewController.view.bounds.size.width
//            splitViewController.preferredPrimaryColumnWidthFraction = 1/2
            splitViewController.viewControllers = [
                NavigationController(rootViewController: MessageListViewController()),
                homeViewController
            ]
            return splitViewController
        } else {
            return homeViewController
        }
    }
}
