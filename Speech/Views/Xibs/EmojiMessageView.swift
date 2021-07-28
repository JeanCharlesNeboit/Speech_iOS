//
//  EmojiMessageView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 14/04/2021.
//

import UIKit
import RxSwift

class EmojiMessageView: AbstractView {
    // MARK: - IBOutlets
    @IBOutlet weak var emojiPlaceholderImageView: UIImageView! {
        didSet {
            emojiPlaceholderImageView.image = SwiftyAssets.UIImages.face_smiling.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @IBOutlet weak var emojiTextField: EmojiTextField!
    @IBOutlet weak var messageTextField: UITextField! {
        didSet {
            messageTextField.setDynamicFont(style: .body)
        }
    }
    
    @IBOutlet weak var inputMessageStackView: InputMessageStackView! {
        didSet {
            inputMessageStackView.type.onNext(.warning)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        Observable.merge(
            emojiTextField.rx.controlEvent(.editingDidBegin).asObservable(),
            emojiTextField.rx.controlEvent(.editingDidEnd).asObservable()
        ).subscribe(onNext: { [weak self] _ in
            self?.updateEmojiPlaceholder()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    func configure(emoji: String?) {
        emojiTextField.text = emoji
        updateEmojiPlaceholder()
    }
    
    // MARK: -
    private func updateEmojiPlaceholder() {
        emojiPlaceholderImageView.isHidden = !emojiTextField.text.isEmptyOrNil || emojiTextField.isEditing
        inputMessageStackView.message.onNext(emojiTextField.isEditing ? SwiftyAssets.Strings.emoji_only_allowed : nil)
    }
}
