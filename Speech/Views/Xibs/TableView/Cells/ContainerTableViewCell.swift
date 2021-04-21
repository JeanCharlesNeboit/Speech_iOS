//
//  ContainerTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 20/04/2021.
//

import UIKit
import TinyConstraints

class ContainerTableViewCell: AbstractTableViewCell {
    // MARK: - Configure
    func configure(view: UIView) {
        contentView.addSubview(view)
        view.edgesToSuperview()
    }
}
