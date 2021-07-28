//
//  NewCategoryViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 14/04/2021.
//

import UIKit
import RxSwift

class NewCategoryViewController: AbstractViewController {
    typealias ViewModel = NewCategoryViewModel
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.keyboardDismissMode = .onDrag
        }
    }
    
    @IBOutlet weak var contentStackView: UIStackView! {
        didSet {
            contentStackView.addArrangedSubview(emojiMessageView)
        }
    }
    
    @IBOutlet weak var createButton: Button! {
        didSet {
            createButton.setTitle(viewModel.mode.saveTitle)
            createButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.viewModel.onCreate { [weak self] result in
                        switch result {
                        case .success():
                            self?.dismiss(animated: true, completion: nil)
                        case .failure(_):
                            break
                        }
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Properties
    let viewModel: ViewModel
    
    private lazy var emojiMessageView: EmojiMessageView = {
        let emojiMessageView: EmojiMessageView = .loadFromXib()
        emojiMessageView.messageTextField.placeholder = SwiftyAssets.Strings.category_name
        
        viewModel.$emoji.subscribe(onNext: { emoji in
            emojiMessageView.configure(emoji: emoji)
        }).disposed(by: disposeBag)
        viewModel.$name.bind(to: emojiMessageView.messageTextField.rx.text).disposed(by: disposeBag)
        
        emojiMessageView.emojiTextField.rx.text.bind(to: viewModel.$emoji).disposed(by: disposeBag)
        emojiMessageView.messageTextField.rx.text.bind(to: viewModel.$name).disposed(by: disposeBag)

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
    
    // MARK: - Configure
    override func configure() {
        super.configure()
        title = viewModel.mode.title
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
}
