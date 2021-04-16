//
//  AboutViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit

class AboutViewController: AbstractViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var appNameLabel: UILabel! {
        didSet {
            appNameLabel.text = Bundle.main.displayName
            appNameLabel.setDynamicFont(style: .title1, weight: .bold)
        }
    }
    @IBOutlet weak var aboutLabel: UILabel! {
        didSet {
            aboutLabel.text = SwiftyAssets.Strings.about_description
            aboutLabel.setDynamicFont(style: .body)
        }
    }
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.settings_about
    }
    
    // MARK: - Configure
    override func configure() {
        super.configure()
        
    }
}
