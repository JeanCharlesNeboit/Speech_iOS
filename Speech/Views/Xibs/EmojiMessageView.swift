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
    @RxBehaviorSubject var emoji: String?
    @RxBehaviorSubject var message: String?
    
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
            
            emojiTextField.rx.text
                .bind(to: $emoji)
                .disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var messageTextField: UITextField! {
        didSet {
            messageTextField.setDynamicFont(style: .body)
            messageTextField.rx.controlEvent(.editingDidBegin)
                .subscribe(onNext: { [weak self] _ in
                    self?.inputMessageStackView.message.onNext(nil)
                }).disposed(by: disposeBag)
            
            messageTextField.rx.text
                .bind(to: $message)
                .disposed(by: disposeBag)
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
        $message.subscribe(onNext: { [weak self] message in
            self?.messageTextField.text = message
        }).disposed(by: disposeBag)
    }
}
