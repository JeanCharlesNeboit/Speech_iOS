//
//  MessageTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/03/2021.
//

import UIKit
import SwiftyKit
import SwiftDate

class MessageTableViewCell: AbstractTableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var emojiContentView: UIView!
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
    func configure(message: Message) {
        emojiContentView.isHidden = message.emoji.isEmptyOrNil
        emojiLabel.text = message.emoji
        messageLabel.text = message.text
        categoryLabel.text = message.category?.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateLabel.text = dateFormatter.string(from: message.addedDate) //.toRelative(style: RelativeFormatter.defaultStyle()).capitalizingFirstLetter()
    }
}
