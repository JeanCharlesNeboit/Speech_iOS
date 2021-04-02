//
//  SectionHeaderFooter.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 02/04/2021.
//

import Foundation

struct SectionHeaderFooter {
    // MARK: - Properties
    let header: String?
    let footer: String?
    
    // MARK: - Initialization
    init(header: String? = nil, footer: String? = nil) {
        self.header = header
        self.footer = footer
    }
}
