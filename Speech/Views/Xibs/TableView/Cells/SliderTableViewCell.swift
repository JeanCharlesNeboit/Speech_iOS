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
        case image(UIImage, UIColor?)
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
    private let imageViewHeight: CGFloat = 30
    
    private(set) lazy var minimumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.aspectRatio(1)
        imageView.height(imageViewHeight)
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
    
    private(set) lazy var maximumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.aspectRatio(1)
        imageView.height(imageViewHeight)
        return imageView
    }()
    
    private(set) var maximumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getFont(style: .largeTitle, weight: .medium)
        return label
    }()
    
    // MARK: - IBOutlets
    @IBOutlet weak var contentStackView: UIStackView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: - Configure
    func configure(config: Config) {
        slider.minimumValue = config.minimumValue
        slider.maximumValue = config.maximumValue
        slider.value = config.initialValue
        slider.step = config.step
        onSlide = config.onSlide
        
        switch config.minimumIcon {
        case .image(let image, let tintColor):
            minimumImageView.image = image.withRenderingMode(.alwaysTemplate)
            if let tintColor = tintColor {
                minimumImageView.tintColor = tintColor
            }
            contentStackView.insertArrangedSubview(minimumImageView, at: 0)
        case .text(let text):
            minimumLabel.text = text
            contentStackView.insertArrangedSubview(minimumLabel, at: 0)
        }
        
        switch config.maximumIcon {
        case .image(let image, let tintColor):
            maximumImageView.image = image.withRenderingMode(.alwaysTemplate)
            if let tintColor = tintColor {
                maximumImageView.tintColor = tintColor
            }
            contentStackView.addArrangedSubview(maximumImageView)
        case .text(let text):
            maximumLabel.text = text
            contentStackView.addArrangedSubview(maximumLabel)
        }
    }
}
