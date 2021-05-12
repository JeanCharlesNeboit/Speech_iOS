//
//  MessageViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit
import RxSwift

class MessageViewController: BaseListViewController {
    // MARK: - Properties
    private lazy var validBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: SwiftyAssets.Strings.generic_validate, style: .done, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.saveMessage()
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return button
    }()
    
    private var emojiMessageViewOnConfigureDisposable: Disposable?
    private lazy var emojiMessageView: EmojiMessageView = .loadFromXib()
    
    private var message: Message
    private var category: Category?
    
    // MARK: - Initialization
    init(message: Message) {
        self.message = message
        category = message.category
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.message_new_title // : SwiftyAssets.Strings.message_edit_title
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = validBarButtonItem
    }

    // MARK: - Configure
    override func configure() {
        super.configure()
        emojiMessageView.message = message.text
        configureDataSource()
    }
    
    private func configureDataSource() {
        sections = [
            Section(model: .init(header: SwiftyAssets.Strings.message_emoji_and_message),
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
            Section(model: .init(header: SwiftyAssets.Strings.generic_category),
                    items: [
                        .details(title: category?.name ?? "", vc: CategoriesListViewController(onSelection: { [weak self] category in
                            guard let self = self else { return }
                            self.navigationController?.popToRootViewController(animated: true)
                            self.category = category
                            self.configureDataSource()
                        }))
                    ])
        ]
    }
    
    // MARK: -
    private func saveMessage() {
        guard let text = emojiMessageView.message else { return }
        
        if message.realm == nil {
            realmService.addObject(self.message)
        }
        
        realmService.write {
            message.emoji = emojiMessageView.emoji
            message.text = text
            message.category = category
        } completion: { result in
            switch result {
            case .success:
                break
            case .failure:
                break
            }
        }
    }
}
