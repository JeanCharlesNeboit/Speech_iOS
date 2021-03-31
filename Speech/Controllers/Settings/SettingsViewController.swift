//
//  SettingsViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/03/2021.
//

import UIKit

class SettingsViewController: AbstractViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: SwiftyAssets.Strings.generic_cancel, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return button
    }()
    
    private lazy var validBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: SwiftyAssets.Strings.generic_validate, style: .done, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            
        }).disposed(by: disposeBag)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = SwiftyAssets.Strings.generic_settings
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = validBarButtonItem
    }
}
