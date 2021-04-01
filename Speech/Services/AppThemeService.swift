//
//  AppThemeService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 31/03/2021.
//

import UIKit

class AppThemeService {
    // MARK: - Properties
    static let shared = AppThemeService()
    
    var placeholderTextColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor.secondaryLabel
        } else {
            return .lightGray
        }
    }
    
    var textColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor.label
        } else {
            return .black
        }
    }
    
    // MARK: - Initialization
    private init() {
        
    }
}
