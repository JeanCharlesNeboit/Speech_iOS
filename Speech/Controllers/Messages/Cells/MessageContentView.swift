//
//  MessageContentView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/07/2021.
//

import UIKit
import SwiftyKit

class MessageContentView: SwiftyUIView {
    // MARK: - IBOutlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emojiImageView: UIImageView!
        
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.setDynamicFont(style: .body)
        }
    }
    
    @IBOutlet weak var categoryLabel: UILabel! {
        didSet {
            categoryLabel.setDynamicFont(style: .footnote)
        }
    }
    
    @IBOutlet weak var separatorHeightConstraint: NSLayoutConstraint! {
        didSet {
            separatorHeightConstraint.constant = 0.33
        }
    }
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: - Configure
    func configure(message: Message, layout: NSLayoutConstraint.Axis, isLast: Bool) {
        stackView.axis = layout
        backgroundColor = layout == .vertical ? ._tertiarySystemBackground : .clear
        
        let emoji = message.emoji
        emojiImageView.image = emoji?.toImage()
        emojiImageView.isHidden = emoji.isEmptyOrNil
        
        messageLabel.text = message.text
        
        let categoryName = message.category?.name
        categoryLabel.text = categoryName
        categoryLabel.isHidden = categoryName.isEmptyOrNil
        
        separatorView.isHidden = isLast
    }
}
