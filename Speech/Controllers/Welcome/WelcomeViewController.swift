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

class WelcomeViewController: ActionViewController {    
    // MARK: - Properties
    override var nibName: String? {
        "ActionViewController"
    }
    
    override var shouldDismissModal: Bool {
        false
    }
    
    private var continueAction: Action {
        .init(title: SwiftyAssets.Strings.generic_continue, completion: { [weak self] in
            self?.navigationController?.pushViewController(CrashlyticsActionViewController(), animated: true)
        })
    }
    
    // MARK: - Initialization
    init() {
        super.init(title: SwiftyAssets.Strings.welcome_title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func configure() {
        super.configure()
        configure(image: SwiftyAssets.UIImages.welcome,
                  subtitle: SwiftyAssets.Strings.welcome_slogan,
                  body: SwiftyAssets.Strings.welcome_description,
                  primaryAction: continueAction)
    }
}
