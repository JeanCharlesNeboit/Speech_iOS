//
//  AbstractViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import RxSwift
import RxKeyboard
import SwiftyKit
import SwiftMessages

class AbstractViewController: UIViewController {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    var isCollapsed: Bool {
        splitViewController?.isCollapsed ?? true
    }
    
    var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode {
        .automatic
    }
    
    var prefersLargeTitles: Bool {
        true
    }
    
    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: SwiftyAssets.Strings.generic_cancel, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return button
    }()
    
    lazy var environmentService = EnvironmentService()
    lazy var searchController: SearchController = SearchController()
    
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
        log.message("🚀 Initialize \(Self.description())")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationItem.largeTitleDisplayMode = largeTitleDisplayMode
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        // https://stackoverflow.com/a/53165371/8353989`
        navigationController?.navigationBar.sizeToFit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Configure
    func configure() {
        hideKeyboardWhenTappedAround()
    }
    
    func configureKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardVisibleHeight in
                let bottomContentInset = keyboardVisibleHeight - self.view.safeAreaInsets.bottom
                self.additionalSafeAreaInsets.bottom = bottomContentInset
            }).disposed(by: disposeBag)
    }
}
