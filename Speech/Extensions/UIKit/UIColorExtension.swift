//
//  UIColorExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 28/07/2021.
//

import UIKit


extension UIColor {
    class var placeholderTextColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor.secondaryLabel
        } else {
            return .lightGray
        }
    }
    
    class var textColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor.label
        } else {
            return .black
        }
    }
    
    class var systemBackgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
}
