//
//  StyleButton.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 04/10/2021.
//

import Foundation

class PrimaryButton: Button {
    // MARK: - Initialization
    override func sharedInit() {
        setStyle(.primary)
        super.sharedInit()
    }
}

class SecondaryButton: Button {
    // MARK: - Initialization
    override func sharedInit() {
        setStyle(.secondary)
        super.sharedInit()
    }
}
