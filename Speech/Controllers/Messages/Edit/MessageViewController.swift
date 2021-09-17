//
//  MessageViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit
import RxSwift

class MessageViewController: BaseListViewController, FormViewController {
    typealias ViewModel = MessageViewModel
    
    // MARK: - IBOutlets
    @IBOutlet var validButton: Button! {
        didSet {
            validButton.setTitle(viewModel.mode.saveTitle)
            validButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.onValidate()
            }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Properties
    let viewModel: ViewModel
    
    private var emojiMessageViewOnConfigureDisposable: Disposable?
    private lazy var emojiMessageView: EmojiMessageView = {
        let emojiMessageView: EmojiMessageView = .loadFromXib()
        emojiMessageView.messageTextField.placeholder = SwiftyAssets.Strings.generic_message
        
        viewModel.$emoji.subscribe(onNext: { emoji in
            emojiMessageView.configure(emoji: emoji)
        }).disposed(by: disposeBag)
        emojiMessageView.emojiTextField.rx.text.bind(to: viewModel.$emoji).disposed(by: disposeBag)

        (emojiMessageView.messageTextField.rx.text <-> viewModel.$message).disposed(by: disposeBag)
        
        return emojiMessageView
    }()

    // MARK: - Initialization
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sharedInit() {
        super.sharedInit()
        title = viewModel.mode.title
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    // MARK: - Configure
    override func configure() {
        super.configure()
        configureDataSource()
        configureTableView()
    }
    
    private func configureDataSource() {
        viewModel.$category.subscribe(onNext: { [weak self] category in
            guard let self = self else { return }
            self.sections = [
                Section(model: .init(header: SwiftyAssets.Strings.message_emoji_and_message),
                        items: [
                            .container(view: self.emojiMessageView, onConfigure: { [weak self] _ in
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
                            .category(category)
                        ])
            ]
        }).disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.rx.modelSelected(BaseListCellType.self)
            .subscribe(onNext: { [weak self] cellType in
                guard let self = self else { return }
                guard case .category = cellType else { return }
                
                let vc = CategoriesListViewController(viewModel: .init(parentCategory: nil, mode: .selection { [weak self] category in
                    guard let self = self else { return }
                    self.navigationController?.popToRootViewController(animated: true)
                    self.viewModel.category = category
                    self.configureDataSource()
                }))
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    
    // MARK: -
    private func onValidate() {
        viewModel.onValidate { [weak self] result in
            switch result {
            case .success():
                self?.dismiss(animated: true, completion: nil)
            case .failure(_):
                break
            }
        }
        
    }
}

#warning("Add remove category feature")
extension MessageViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard case .category = sections[indexPath.section].items[indexPath.row] else {
            return UISwipeActionsConfiguration()
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: SwiftyAssets.Strings.generic_delete) { [weak self] _, _, success in
            guard let self = self else { return }
            self.viewModel.category = nil
            success(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
}
