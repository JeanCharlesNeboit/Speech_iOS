//
//  EmptyView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/07/2021.
//

import UIKit

class EmptyView: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    // MARK: - Configure
    func configure(image: UIImage, title: String, body: String) {
        imageView.image = image
        titleLabel.text = title
        bodyLabel.text = body
    }
}
