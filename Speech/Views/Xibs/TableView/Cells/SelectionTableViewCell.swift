//
//  SelectionTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/09/2021.
//

import UIKit

class SelectionTableViewCell: DetailsTableViewCell {
    // MARK: - Properties
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - Configure
    func configure(config: Config, isSelected: Bool) {
        configure(config: config)
        let image = isSelected ? SwiftyAssets.UIImages.checkmark_circle_fill : SwiftyAssets.UIImages.circle
        iconImageView.image = image.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = SwiftyAssets.UIColors.primary
    }
}
