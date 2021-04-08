//
//  UIFontExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 08/04/2021.
//

import UIKit

extension UIFont {
    static func getFont(style: FontStyle, weight: UIFont.Weight = .regular) -> UIFont {
        let font = UIFont.systemFont(ofSize: style.size, weight: weight)
        return UIFontMetrics(forTextStyle: style.style).scaledFont(for: font)
    }
}
