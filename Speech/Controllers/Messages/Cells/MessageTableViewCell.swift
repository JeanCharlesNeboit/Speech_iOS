//
//  MessageTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/03/2021.
//

import UIKit

class MessageTableViewCell: AbstractTableViewCell {
    // MARK: - Configure
    func configure(message: Message, layout: NSLayoutConstraint.Axis) {
        let messageView: MessageContentView = .loadFromXib()
        messageView.configure(message: message, layout: layout)
        addSubview(messageView)
        messageView.edgesToSuperview()
    }
}
