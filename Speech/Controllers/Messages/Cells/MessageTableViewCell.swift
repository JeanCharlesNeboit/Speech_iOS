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
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.setDynamicFont(style: .footnote)
        }
    }
    
    // MARK: - Configure
    func configure(message: Message) {
        emojiContentView.isHidden = message.emoji.isEmptyOrNil
        emojiLabel?.text = message.emoji
        messageLabel?.text = message.text
        dateLabel?.text = message.addedDate.toRelative(style: RelativeFormatter.defaultStyle()).capitalizingFirstLetter()
    }
}
