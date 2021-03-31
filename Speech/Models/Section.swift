//
//  Section.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/03/2021.
//

import Foundation

class Section<T> {
    // MARK: - Properties
    var header: String?
    var footer: String?
    var items: [T]
    
    // MARK: - Initialization
    init(header: String? = nil, footer: String? = nil, items: [T]) {
        self.header = header
        self.footer = footer
        self.items = items
    }
}
