//
//  Label.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 15/04/2021.
//

import UIKit

extension UILabel {
    func setDynamicFont(style: FontStyle, weight: UIFont.Weight = .regular) {
        font = UIFont.getFont(style: style, weight: weight)
        adjustsFontForContentSizeCategory = true
    }
}

extension UITextField {
    func setDynamicFont(style: FontStyle, weight: UIFont.Weight = .regular) {
        font = UIFont.getFont(style: style, weight: weight)
        adjustsFontForContentSizeCategory = true
    }
}

extension UITextView {
    func setDynamicFont(style: FontStyle, weight: UIFont.Weight = .regular) {
        font = UIFont.getFont(style: style, weight: weight)
        adjustsFontForContentSizeCategory = true
    }
}
