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
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // containerView.layer.cornerRadius = 10
    }
    
    // MARK: - Configure
    func configure(message: Message) {
        textLabel?.text = message.text
        detailTextLabel?.text = message.addedDate?.toRelative(style: RelativeFormatter.defaultStyle()).capitalizingFirstLetter()
    }
}
