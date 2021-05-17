//
//  WelcomeViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 07/04/2021.
//

import UIKit

class WelcomeViewController: AbstractViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var welcomeImageView: UIImageView!
    @IBOutlet weak var sloganLabel: UILabel! {
        didSet {
            sloganLabel.font = UIFont.getFont(style: .title2, weight: .bold)
            sloganLabel.text = SwiftyAssets.Strings.welcome_slogan
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = SwiftyAssets.Strings.welcome_description
        }
    }
    
    @IBOutlet weak var getStartedButton: Button! {
        didSet {
            getStartedButton.setTitle(SwiftyAssets.Strings.welcome_get_started)
            getStartedButton.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    self?.dismiss(animated: true, completion: nil)
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.welcome_title
    }
    
    // MARK: - Lifecycle
    override func configure() {
        super.configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DefaultsStorage.welcomeDone = true
    }
}
