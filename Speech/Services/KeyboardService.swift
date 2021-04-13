//
//  KeyboardService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

import UIKit
import RxSwift
import RxKeyboard

class KeyboardService {
    // MARK: - Properties
    static let shared = KeyboardService()
    
    private let disposeBag = DisposeBag()
    
    private(set) var isKeyboardHidden: Bool = true
    private(set) var keyboardHeight: CGFloat = 0
    
    // MARK: - Initialization
    init() {
        listenKeyboard()
    }
    
    // MARK: -
    private func listenKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                self.keyboardHeight = keyboardVisibleHeight
            }).disposed(by: disposeBag)
        
        RxKeyboard.instance.isHidden
            .drive(onNext: { [weak self] isHidden in
                guard let self = self else { return }
                self.isKeyboardHidden = isHidden
            }).disposed(by: disposeBag)
    }
}
