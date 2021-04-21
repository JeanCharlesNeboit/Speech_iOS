//
//  DetailsTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit

class DetailsTableViewCell: AbstractTableViewCell {
    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Configure
    func configure(title: String) {
        titleLabel.text = title
    }
}
