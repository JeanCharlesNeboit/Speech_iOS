//
//  SettingsViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/03/2021.
//

import UIKit
import SwiftyKit
import RxSwift
import RxDataSources
import SwiftMessages

class SettingsViewController: BaseSettingsViewController {
    // MARK: - Properties
    private var widthConstraint: NSLayoutConstraint?
    
    private static var SettingsSections: [Section] {
        [
            Section(model: .init(),
                    items: [
                        .details(title: SwiftyAssets.Strings.settings_appearance),
                        .details(title: SwiftyAssets.Strings.settings_voice)
                    ]),
            Section(model: .init(footer: "\(Bundle.main.info)\n\(SwiftyAssets.Strings.settings_made_in_auvergne)"),
                    items: [
                        .details(title: SwiftyAssets.Strings.settings_about),
                        .details(title: SwiftyAssets.Strings.settings_open_source),
                        .details(title: SwiftyAssets.Strings.settings_thanks)
                    ])
        ]
    }
    
//    public override var preferredContentSize: CGSize {
//        get {
//            let screenBounds = UIScreen.main.bounds
//            return CGSize(width: screenBounds.width * 0.5, height: screenBounds.height * 0.6)
//        }
//
//        set { super.preferredContentSize = newValue }
//    }
    
    private lazy var validBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: SwiftyAssets.Strings.generic_validate, style: .done, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return button
    }()
    
    // MARK: - Initialization
    init() {
        super.init(title: SwiftyAssets.Strings.generic_settings, sections: Self.SettingsSections)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func configure() {
        super.configure()
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = validBarButtonItem
    }
}
