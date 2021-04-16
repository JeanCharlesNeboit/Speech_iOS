//
//  NewCategoryViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 14/04/2021.
//

import UIKit
import RxSwift

class NewCategoryViewController: AbstractViewController {
    // MARK: - Properties
    private var parentCategory: Category?
    private lazy var emojiMessageView: EmojiMessageView = .loadFromXib()
    
    // MARK: - IBOutlets
    @IBOutlet weak var contentStackView: UIStackView! {
        didSet {
            contentStackView.addArrangedSubview(emojiMessageView)
        }
    }
    
    @IBOutlet weak var createButton: Button! {
        didSet {
            createButton.setTitle(SwiftyAssets.Strings.generic_create)
            createButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    guard let name = self.emojiMessageView.message else { return }
                    let category = Category(parentCategory: self.parentCategory, name: name)
                    if let parentCategory = self.parentCategory {
                        self.realmService.beginWrite()
                        parentCategory.subCategories.append(category)
                        self.realmService.commit { _ in
                            
                        }
                    } else {
                        self.realmService.addObject(category)
                    }
                    self.dismiss(animated: true, completion: nil)
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Initialization
    init(parentCategory: Category?) {
        self.parentCategory = parentCategory
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.new_category_title
    }
}
