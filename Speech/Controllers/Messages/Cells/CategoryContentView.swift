//
//  CategoryContentView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/09/2021.
//

import UIKit
import SwiftyKit

class CategoryContentView: SwiftyUIView {
    // MARK: - IBOutlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.setDynamicFont(style: .body)
        }
    }
    
    // MARK: - Configure
    func configure(category: Category) {
        let layout: NSLayoutConstraint.Axis = .vertical
        stackView.axis = layout
        backgroundColor = layout == .vertical ? ._tertiarySystemBackground : .clear
        
        badgeLabel.text = "\(category.messages.count)"
        
        let emoji = category.emoji
        emojiLabel.text = emoji
        emojiLabel.isHidden = emoji.isEmptyOrNil
        
        messageLabel.text = category.name
    }
}
