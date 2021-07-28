//
//  TextView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/03/2021.
//

import UIKit
import RxSwift
import RxCocoa

class TextView: UITextView {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    @RxBehaviorSubject private var isPlaceholderActive: Bool = true
    @RxBehaviorSubject var placeholder: String = ""
    
    override var text: String! {
        get {
            super.text
        } set {
            if !isPlaceholderActive {
                super.text = newValue
                if super.text.isEmptyOrNil && !isFirstResponder {
                    isPlaceholderActive = true
                }
            } else {
                if !newValue.isEmptyOrNil {
                    isPlaceholderActive = false
                    super.text = newValue
                }
            }
        }
    }
    
    var enteredText: String? {
        let trimmingText = text.trimmingCharacters(in: .whitespaces)
        guard !isPlaceholderActive,
              !trimmingText.isEmpty else { return nil }
        return trimmingText
    }
    
    // MARK: - Initialization
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        configure()
    }
    
    // MARK: - Configure
    private func configure() {
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        
        Observable.combineLatest($isPlaceholderActive, $placeholder)
            .subscribe(onNext: { [weak self] isPlaceholderActive, placeholder in
                self?.updatePlaceholder(isPlaceholderActive, placeholder)
            }).disposed(by: disposeBag)
        
        rx.didBeginEditing.subscribe(onNext: { [weak self] _ in
            self?.unsetPlaceholderIfNeeded()
        }).disposed(by: disposeBag)

        rx.didEndEditing.subscribe(onNext: { [weak self] _ in
            self?.setPlaceholderIfNeeded()
        }).disposed(by: disposeBag)
    }
    
    // MARK: -
    private func setPlaceholderIfNeeded() {
        if text.isEmpty {
            isPlaceholderActive = true
        }
    }

    private func unsetPlaceholderIfNeeded() {
        if isPlaceholderActive {
            isPlaceholderActive = false
        }
    }
    
    private func updatePlaceholder(_ isPlaceholderActive: Bool, _ placeholder: String) {
        super.text = isPlaceholderActive ? placeholder : nil
        textColor = isPlaceholderActive ? .placeholderTextColor : .textColor
    }
    
    // MARK: -
//    func clear() {
//        guard !isPlaceholderActive else { return }
//        text = nil
//    }
//
//    func append(text appendingText: String) {
////        unsetPlaceholderIfNeeded()
//        let newText = [enteredText ?? "", appendingText].joined(separator: " ").trimmingCharacters(in: .whitespaces)
//        text = newText
//    }
}
