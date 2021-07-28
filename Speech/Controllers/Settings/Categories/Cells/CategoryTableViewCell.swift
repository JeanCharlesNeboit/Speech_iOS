//
//  CategoryTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 19/04/2021.
//

import UIKit

class CategoryTableViewCell: AbstractTableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subCategoriesLabel: UILabel!
    
    // MARK: - Configure
    func configure(category: Category) {
        nameLabel.text = category.name
        nameLabel.setDynamicFont(style: .body)
        
        emojiLabel.isHidden = category.emoji.isEmptyOrNil
        emojiLabel.text = category.emoji
        
        let subCategories = category.subCategories
        subCategoriesLabel.isHidden = subCategories.isEmpty
        subCategoriesLabel.text = String(format: subCategories.count <= 1 ? SwiftyAssets.Strings.sub_categories_single : SwiftyAssets.Strings.sub_categories_plurial, "\(subCategories.count)")
        subCategoriesLabel.setDynamicFont(style: .footnote)
        
        accessoryType = .disclosureIndicator
    }
}
