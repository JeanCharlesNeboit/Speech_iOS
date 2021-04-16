//
//  EmojiMessageView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 14/04/2021.
//

import UIKit
import RxSwift

class EmojiMessageView: AbstractView {
    // MARK: - Properties
    var message: String? {
        messageTextField.text
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var emojiPlaceholderImageView: UIImageView!
    @IBOutlet weak var emojiTextField: UITextField! {
        didSet {
            emojiTextField.rx.controlEvent(.editingDidBegin)
                .subscribe(onNext: { [weak self] _ in
                    self?.emojiPlaceholderImageView.isHidden = true
                    self?.inputMessageStackView.message.onNext("Only emoji is allowed*")
                }).disposed(by: disposeBag)
            
            emojiTextField.rx.controlEvent(.editingDidEnd)
                .filter { [weak self] in
                    self?.emojiTextField.text?.isEmpty ?? true
                    
                }.subscribe(onNext: { [weak self] _ in
                    self?.emojiPlaceholderImageView.isHidden = false
                }).disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var messageTextField: UITextField! {
        didSet {
            messageTextField.rx.controlEvent(.editingDidBegin)
                .subscribe(onNext: { [weak self] _ in
                    self?.inputMessageStackView.message.onNext(nil)
                }).disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var inputMessageStackView: InputMessageStackView! {
        didSet {
            inputMessageStackView.type.onNext(.warning)
        }
    }
}
