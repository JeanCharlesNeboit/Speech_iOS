//
//  MessageTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/03/2021.
//

import UIKit

class MessageTableViewCell: AbstractTableViewCell {
    // MARK: - Properties
    private lazy var messageView: MessageContentView = .loadFromXib()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(messageView)
        messageView.edgesToSuperview()
    }
    
    // MARK: - Configure
    func configure(message: Message, layout: NSLayoutConstraint.Axis) {
        messageView.configure(message: message, layout: layout)
    }
}
