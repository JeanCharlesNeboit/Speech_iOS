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
    @IBOutlet weak var emojiLabel: UILabel!
        
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
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.setDynamicFont(style: .caption2)
        }
    }
    
    // MARK: - Configure
    func configure(message: Message, layout: NSLayoutConstraint.Axis) {
        stackView.axis = layout
        backgroundColor = layout == .vertical ? ._tertiarySystemBackground : .clear
        
        let emoji = message.emoji
        emojiLabel.text = emoji
        emojiLabel.isHidden = emoji.isEmptyOrNil
        
        messageLabel.text = message.text
        
        let categoryName = message.category?.name
        categoryLabel.text = categoryName
        categoryLabel.isHidden = categoryName.isEmptyOrNil
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .none
//        dateLabel.text = dateFormatter.string(from: message.addedDate) //.toRelative(style: RelativeFormatter.defaultStyle()).capitalizingFirstLetter()
    }
}
