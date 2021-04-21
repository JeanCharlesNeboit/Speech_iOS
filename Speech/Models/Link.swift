//
//  Link.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 19/04/2021.
//

import Foundation

struct Link {
    // MARK: - Properties
    let title: String
    let urlString: String
    let inApp: Bool
    
    // MARK: - Initialization
    init(title: String, urlString: String, inApp: Bool = true) {
        self.title = title
        self.urlString = urlString
        self.inApp = inApp
    }
}
