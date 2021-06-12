//
//  MessageTileView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 12/06/2021.
//

import UIKit
import SwiftyKit

class MessageTileView: AbstractView {
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        layer.cornerRadius = 8
    }
    
    // MARK: - Configure
    func configure(message: Message) {
        titleLabel.text = message.text
    }
}
