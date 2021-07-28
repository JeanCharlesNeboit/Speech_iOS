//
//  UIViewControllerExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit

extension UIView {
    static func getBottomContentInset(view: UIView,
                                      bottomConstraint: NSLayoutConstraint) -> CGFloat {
        [
            view.bounds.height,
            bottomConstraint.constant
         ].reduce(0, +)
    }
}
