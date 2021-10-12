//
//  CategoryContentView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/09/2021.
//

import UIKit
import SwiftyKit

class CategoryContentView: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.setDynamicFont(style: .body)
        }
    }
    
    // MARK: - Configure
    func configure(category: Category) {
        let layout: NSLayoutConstraint.Axis = .vertical
        stackView.axis = layout
        backgroundView.backgroundColor = layout == .vertical ? ._tertiarySystemBackground : .clear
        
        badgeLabel.text = "\(category.messages.count)"
        
        let emoji = category.emoji
        emojiImageView.isHidden = emoji.isEmptyOrNil
        emojiImageView.image = emoji?.toImage() // ?? SwiftyAssets.UIImages.face_smiling
        
        messageLabel.text = category.name
    }
}
