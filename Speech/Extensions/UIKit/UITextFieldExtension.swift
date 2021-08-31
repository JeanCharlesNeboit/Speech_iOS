//
//  UITextFieldExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 31/08/2021.
//

import UIKit

extension UITextField {
     func setNextTarget(toTextField textField: UITextField) {
         returnKeyType = .next
         addTarget(textField, action: #selector(becomeFirstResponder), for: UIControl.Event.editingDidEndOnExit)
     }
}
