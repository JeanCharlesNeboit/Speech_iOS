//
//  ActionViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 04/10/2021.
//

import UIKit
import Combine

struct Action {
    let title: String
    let completion: (() -> Void)
}

class ActionViewController: AbstractViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(style: .title2, weight: .bold)
        }
    }
    @IBOutlet weak var bodyLabel: UILabel! {
        didSet {
            bodyLabel.font = UIFont.getFont(style: .body)
        }
    }
    @IBOutlet weak var primaryButton: PrimaryButton! {
        didSet {
            primaryButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.primaryAction?.completion()
            }).disposed(by: disposeBag)
        }
    }
    @IBOutlet weak var secondaryButton: SecondaryButton! {
        didSet {
            secondaryButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.secondaryAction?.completion()
            }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Properties
    private var primaryAction: Action?
    private var secondaryAction: Action?
    
    // MARK: - Initialization
    init(title: String) {
        super.init()
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Configure
    func configure(image: UIImage, subtitle: String, body: String, primaryAction: Action, secondaryAction: Action? = nil) {
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        
        imageView.image = image
        subtitleLabel.text = subtitle
        bodyLabel.text = body
        primaryButton.setTitle(primaryAction.title)
        
        secondaryButton.isHidden = secondaryAction == nil
        if let secondaryAction = secondaryAction {
            secondaryButton.setTitle(secondaryAction.title)
        }
    }
}
