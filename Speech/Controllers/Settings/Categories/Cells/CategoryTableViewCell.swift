//
//  CategoryTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 19/04/2021.
//

import UIKit

class CategoryTableViewCell: AbstractTableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subCategoriesLabel: UILabel!
    
    // MARK: - Configure
    func configure(category: Category) {
        nameLabel.text = category.name
        subCategoriesLabel.text = "\(category.subCategories.count)*"
        accessoryType = category.subCategories.count > 0 ? .disclosureIndicator : .none
    }
}
