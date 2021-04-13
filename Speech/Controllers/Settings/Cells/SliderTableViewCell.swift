//
//  SliderTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

import UIKit

// https://stackoverflow.com/questions/35452185/how-can-i-make-a-uislider-with-step-value
// https://stackoverflow.com/questions/24726411/how-to-customze-uislider-to-get-stepps-visible
class SliderTableViewCell: AbstractTableViewCell {
    // MARK: - State
    struct State {
        let minimumValue: Float
        let maximumValue: Float
        let initialValue: Float
        let onSlide: ((Float) -> Void)?
    }
    
    // MARK: - Properties
    private var onSlide: ((Float) -> Void)?
    
    // MARK: - IBOutlets
    @IBOutlet weak var minimumLabel: UILabel! {
        didSet {
            minimumLabel.font = UIFont.getFont(style: .body, weight: .medium)
        }
    }
    
    @IBOutlet weak var slider: UISlider! {
        didSet {
            slider.minimumTrackTintColor = SwiftyAssets.UIColors.primary
            slider.rx.value
                .subscribe(onNext: { value in
                    self.onSlide?(value)
                }).disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var maximumLabel: UILabel! {
        didSet {
            maximumLabel.font = UIFont.getFont(style: .largeTitle, weight: .medium)
        }
    }
    
    // MARK: - Configure
    func configure(state: State) {
        slider.minimumValue = state.minimumValue
        slider.maximumValue = state.maximumValue
        slider.value = state.initialValue
        onSlide = state.onSlide
    }
}
