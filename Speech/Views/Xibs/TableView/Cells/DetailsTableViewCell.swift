//
//  DetailsTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import Foundation

class DetailsTableViewCell: AbstractTableViewCell {
    // MARK: - Configure
    func configure(title: String) {
        textLabel?.text = title
    }
}
