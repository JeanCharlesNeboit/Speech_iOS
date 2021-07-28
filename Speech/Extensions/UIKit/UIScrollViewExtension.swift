//
//  UIScrollViewExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 28/07/2021.
//

import UIKit

extension UIScrollView {
    func setBottomContentInset(_ inset: CGFloat) {
         contentInset.bottom = inset
         scrollIndicatorInsets = contentInset
         keyboardDismissMode = .interactive
     }
}
