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
    
    private var isPlaceholderActiveBehaviorSubject = BehaviorSubject<Bool>(value: true)
    private var isPlaceholderActive: Bool {
        get {
            (try? isPlaceholderActiveBehaviorSubject.value()) ?? false
        }
        set {
            isPlaceholderActiveBehaviorSubject.onNext(newValue)
        }
        
    }
    
    var placeholder: String = "" {
        didSet {
            setPlaceholderIfNeeded()
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
        
        isPlaceholderActiveBehaviorSubject
            .subscribe(onNext: { [weak self] isPlaceholderActive in
                guard let self = self else { return }
                self.text = isPlaceholderActive ? self.placeholder : nil
                self.textColor = isPlaceholderActive ? AppThemeService.shared.placeholderTextColor : AppThemeService.shared.textColor
            }).disposed(by: disposeBag)
        
        rx.didBeginEditing.subscribe(onNext: { [self] _ in
            unsetPlaceholderIfNeeded()
        }).disposed(by: disposeBag)
        
        rx.didEndEditing.subscribe(onNext: { [self] _ in
            setPlaceholderIfNeeded()
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
    
    // MARK: -
    func clear() {
        guard !isPlaceholderActive else { return }
        text = nil
    }
    
    func append(text appendingText: String) {
        unsetPlaceholderIfNeeded()
        let newText = [enteredText ?? "", appendingText].joined(separator: " ").trimmingCharacters(in: .whitespaces)
        text = newText
    }
}
