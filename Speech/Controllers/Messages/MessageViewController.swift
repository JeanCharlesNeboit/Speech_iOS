//
//  MessageViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit

class MessageViewController: AbstractViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var emojiTextField: EmojiTextField! {
        didSet {
            emojiTextField.font = UIFont.getFont(style: .largeTitle)
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            emojiTextField.font = UIFont.getFont(style: .body)
        }
    }
    
    // MARK: - Properties
    private lazy var validBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: SwiftyAssets.Strings.generic_validate, style: .done, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return button
    }()
    
    private var message: Message?
    
    // MARK: - Initialization
    init(message: Message) {
        self.message = message
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Configure
    override func configure() {
        title = message == nil ? SwiftyAssets.Strings.message_new_title : SwiftyAssets.Strings.message_edit_title
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = validBarButtonItem
        
        nameTextField.text = message?.text
    }
}
