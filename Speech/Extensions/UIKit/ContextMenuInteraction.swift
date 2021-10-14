//
//  MessageContextMenuInteractions.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 14/10/2021.
//

import UIKit

@available(iOS 13.0, *)
class ContextMenuInteraction<T>: UIContextMenuInteraction {
    // MARK: - Properties
    let item: T
    
    // MARK: - Initialization
    init(item: T, delegate: UIContextMenuInteractionDelegate) {
        self.item = item
        super.init(delegate: delegate)
    }
}
