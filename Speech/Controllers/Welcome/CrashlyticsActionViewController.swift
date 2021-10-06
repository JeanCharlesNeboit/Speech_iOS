//
//  CrashlyticsActionViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 04/10/2021.
//

import UIKit

class CrashlyticsActionViewController: ActionViewController {
    // MARK: - Properties
    override var nibName: String? {
        "ActionViewController"
    }
    
    override var shouldDismissModal: Bool {
        false
    }
    
    private var allowAction: Action {
        .init(title: SwiftyAssets.Strings.generic_allow, completion: { [weak self] in
            self?.onChoiceMade(enable: true)
        })
    }
    
    private var denyAction: Action {
        .init(title: SwiftyAssets.Strings.generic_deny, completion: { [weak self] in
            self?.onChoiceMade(enable: false)
        })
    }
    
    // MARK: - Initialization
    init() {
        super.init(title: SwiftyAssets.Strings.help_us)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let appName = Bundle.main.displayName
        let subtitle = String(format: SwiftyAssets.Strings.help_us_improve, appName)
        let body = String(format: SwiftyAssets.Strings.crash_reports_description, appName, appName)
        configure(subtitle: subtitle, body: body, primaryAction: allowAction, secondaryAction: denyAction)
    }
    
    // MARK: -
    private func onChoiceMade(enable: Bool) {
        DefaultsStorage.enableCrashlyticsCollection = enable
        DefaultsStorage.onboardingDone = true
        dismiss(animated: true, completion: nil)
    }
}
