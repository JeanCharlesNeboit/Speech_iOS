//
//  DetailsTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit

class DetailsTableViewCell: AbstractTableViewCell {
    // MARK: -
    struct Config {
        let title: String
        let subtitle: String?
        
        init(title: String, subtitle: String? = nil) {
            self.title = title
            self.subtitle = subtitle
        }
    }
    
    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.getFont(style: .body, weight: .regular)
        }
    }
    
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(style: .caption1, weight: .regular)
        }
    }
    
    // MARK: - Configure
    func configure(config: Config, accessoryType: UITableViewCell.AccessoryType = .none) {
        titleLabel.text = config.title
        subtitleLabel.text = config.subtitle
        subtitleLabel.isHidden = config.subtitle.isEmptyOrNil
        self.accessoryType = accessoryType
    }
}
