//
//  SwitchTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

import UIKit
import RxSwift

class SwitchTableViewCell: AbstractTableViewCell {
    // MARK: - Config
    struct Config {
        let title: String
        let initialValue: Bool
        let onSwitch: ((Bool) -> Void)?
    }
    
    // MARK: - Properties
    private var onSwitch: ((Bool) -> Void)?
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch! {
        didSet {
            uiSwitch.rx.isOn
                .subscribe(onNext: { value in
                    self.onSwitch?(value)
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: - Configure
    func configure(config: Config) {
        titleLabel.text = config.title
        uiSwitch.isOn = config.initialValue
        onSwitch = config.onSwitch
    }
}
