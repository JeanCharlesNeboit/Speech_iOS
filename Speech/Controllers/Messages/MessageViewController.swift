//
//  MessageViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit
import RxSwift

class MessageViewController: BaseListViewController {
    // MARK: - IBOutlets
    
    // MARK: - Properties
    private lazy var validBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: SwiftyAssets.Strings.generic_validate, style: .done, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return button
    }()
    
    private var emojiMessageViewOnConfigureDisposable: Disposable?
    private lazy var emojiMessageView: EmojiMessageView = .loadFromXib()
    private var message: Message?
    
    // MARK: - Initialization
    init(message: Message) {
        self.message = message
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func sharedInit() {
        super.sharedInit()
        title = message == nil ? SwiftyAssets.Strings.message_new_title : SwiftyAssets.Strings.message_edit_title
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = validBarButtonItem
    }

    // MARK: - Configure
    override func configure() {
        super.configure()
        emojiMessageView.message = message?.text
        
        sections = [
            Section(model: .init(),
                    items: [
                        .container(view: emojiMessageView, onConfigure: { [weak self] _ in
                            guard let self = self else { return }
                            self.emojiMessageViewOnConfigureDisposable = self.emojiMessageView
                                .inputMessageStackView
                                .message
                                .subscribe(onNext: { [weak self] _ in
                                    self?.tableView.performBatchUpdates(nil, completion: nil)
                                })
                        })
                    ]),
            Section(model: .init(),
                    items: [
                        .details(title: "Category*", vc: CategoriesListViewController())
                    ])
        ]
    }
}
