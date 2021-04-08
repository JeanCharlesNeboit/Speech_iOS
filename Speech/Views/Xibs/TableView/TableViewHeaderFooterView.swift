//
//  TableViewHeaderFooterView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit

class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    // MARK: - IBOutlets
    @IBOutlet weak var headerFooterLabel: UILabel!
    
    // MARK: - Configure
    func configure(text: String?) {
        headerFooterLabel.text = text
    }
}
