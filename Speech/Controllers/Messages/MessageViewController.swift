//
//  MessageViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit

class MessageViewController: AbstractViewController {
    // MARK: - IBOutlets
    
    // MARK: - Properties
    private lazy var validBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: SwiftyAssets.Strings.generic_validate, style: .done, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Configure
    override func configure() {
        title = SwiftyAssets.Strings.message_new_title
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = validBarButtonItem
    }
}
