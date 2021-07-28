//
//  AbstractViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import RxSwift
import SwiftyKit
import SwiftMessages

class AbstractViewController: UIViewController {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    lazy var realmService = RealmService()
    
    var isCollapsed: Bool {
//        splitViewController?.isCollapsed ?? true
        #warning("Check this")
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: SwiftyAssets.Strings.generic_cancel, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return button
    }()
    
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    func sharedInit() {
//        view.backgroundColor = AppThemeService.shared.systemBackgroundColor
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Configure
    func configure() {
        
    }
}
