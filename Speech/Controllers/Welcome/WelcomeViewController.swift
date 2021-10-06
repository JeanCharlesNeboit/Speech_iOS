//
//  WelcomeViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 07/04/2021.
//

import UIKit

class ScaledHeightImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }
}

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
            descriptionLabel.font = UIFont.getFont(style: .body)
            descriptionLabel.text = SwiftyAssets.Strings.welcome_description
        }
    }
    
    @IBOutlet weak var getStartedButton: PrimaryButton! {
        didSet {
            getStartedButton.setTitle(SwiftyAssets.Strings.generic_continue)
            getStartedButton.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    self?.navigationController?.pushViewController(CrashlyticsActionViewController(), animated: true)
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Properties
    override var shouldDismissModal: Bool {
        false
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
}
