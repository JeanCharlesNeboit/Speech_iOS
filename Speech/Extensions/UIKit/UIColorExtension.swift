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
    
    // MARK: - SystemMaterials
    class var _secondarySystemFill: UIColor {
        if #available(iOS 13.0, *) {
            return .secondarySystemFill
        } else {
            return .black.withAlphaComponent(0.2)
        }
    }
    
    // MARK: - SystemBackground
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
            return .lightGray
        }
    }
    
    class var _tertiarySystemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiarySystemBackground
        } else {
            return .white
        }
    }
    
    // MARK: - SystemGroupedBackground
    class var _systemGroupedBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGroupedBackground
        } else {
            return .lightGray
        }
    }
    
    class var _secondarySystemGroupedBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .secondarySystemGroupedBackground
        } else {
            return .white
        }
    }
    
    class var _tertiarySystemGroupedBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiarySystemGroupedBackground
        } else {
            return .lightGray
        }
    }
}
