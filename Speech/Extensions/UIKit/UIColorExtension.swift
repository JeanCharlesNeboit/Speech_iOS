//
//  UIColorExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 28/07/2021.
//

import UIKit

extension UIColor {
    class var placeholder: UIColor {
        if #available(iOS 13, *) {
            return UIColor.secondaryLabel
        } else {
            return .lightGray
        }
    }
    
    class var text: UIColor {
        if #available(iOS 13, *) {
            return UIColor.label
        } else {
            return .black
        }
    }
    
    class var _systemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    class var _secondarySystemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .secondarySystemBackground
        } else {
            return .white
        }
    }
    
    class var _tertiarySystemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiarySystemBackground
        } else {
            return .white
        }
    }
}
