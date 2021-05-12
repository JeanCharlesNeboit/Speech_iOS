//
//  SliderTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

import UIKit
import SwiftyKit

// https://stackoverflow.com/questions/24726411/how-to-customze-uislider-to-get-stepps-visible
class SliderTableViewCell: AbstractTableViewCell {
    // MARK: - Enums
    enum IconType {
        case image(UIImage)
        case text(String)
    }
    
    // MARK: - Config
    struct Config {
        let minimumValue: Float
        let minimumIcon: IconType
        let maximumValue: Float
        let maximumIcon: IconType
        let initialValue: Float
        let step: Float
        let onSlide: ((Float) -> Void)?
    }
    
    // MARK: - Properties
    private var onSlide: ((Float) -> Void)?
    
    private(set) lazy var minimumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.aspectRatio(1)
        imageView.height(24)
        return imageView
    }()
    
    private(set) var minimumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getFont(style: .body, weight: .medium)
        return label
    }()
    
    @IBOutlet weak var slider: SwitchSlider! {
        didSet {
            slider.rx.value
                .subscribe(onNext: { value in
                    self.onSlide?(value)
                }).disposed(by: disposeBag)
        }
    }
    
    private(set) var maximumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.aspectRatio(1)
        imageView.height(24)
        return imageView
    }()
    
    private(set) var maximumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getFont(style: .largeTitle, weight: .medium)
        return label
    }()
    
    // MARK: - IBOutlets
    @IBOutlet weak var contentStackView: UIStackView!
    
    // MARK: - Configure
    func configure(config: Config) {
        slider.minimumValue = config.minimumValue
        slider.maximumValue = config.maximumValue
        slider.value = config.initialValue
        slider.step = config.step
        onSlide = config.onSlide
        
        switch config.minimumIcon {
        case .image(let image):
            minimumImageView.image = image
            contentStackView.insertArrangedSubview(minimumImageView, at: 0)
        case .text(let text):
            minimumLabel.text = text
            contentStackView.insertArrangedSubview(minimumLabel, at: 0)
        }
        
        switch config.maximumIcon {
        case .image(let image):
            maximumImageView.image = image
            contentStackView.addArrangedSubview(maximumImageView)
        case .text(let text):
            maximumLabel.text = text
            contentStackView.addArrangedSubview(maximumLabel)
        }
    }
}
