//
//  LoadViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/09/2021.
//

import UIKit

class LoadViewController: AbstractViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIWindow.currentWindow?.set(rootViewController: UIViewController.main)
        }
    }
}
