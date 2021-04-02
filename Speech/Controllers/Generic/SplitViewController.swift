//
//  SplitViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 02/04/2021.
//

import UIKit

class SplitViewController: UISplitViewController {
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        preferredDisplayMode = .oneBesideSecondary
        // maximumPrimaryColumnWidth = splitViewController.view.bounds.size.width
        // preferredPrimaryColumnWidthFraction = 1/2
    }
    
    // MARK: - Configure
    func configure(main: UIViewController, details: UIViewController) {
        viewControllers = [main, details]
    }
}
