//
//  EmojiTextField.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 14/04/2021.
//

import UIKit

class EmojiTextField: UITextField {
//    override var textInputMode: UITextInputMode? {
//        for mode in UITextInputMode.activeInputModes {
//            print("Mode \(mode.primaryLanguage)")
//        }
//        for mode in UITextInputMode.activeInputModes where mode.primaryLanguage == "emoji" {
//            return mode
//        }
//        return nil
//    }
    
    // https://stackoverflow.com/questions/3699727/hide-the-cursor-of-an-uitextfield
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        let height = rect.size.height/2
        rect.origin.y += height/2
        rect.size.height = height
        return rect
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        delegate = self
    }
}

extension EmojiTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty,
              string != "\n" else { return true }
        guard let firstCharacter = string.first,
              firstCharacter.isEmoji else { return false }
        text = nil
        return true
    }
}
