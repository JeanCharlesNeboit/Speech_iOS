//
//  NavigationController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/03/2021.
//

import UIKit
import RxSwift

class NavigationController: UINavigationController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        sharedInit()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        configure()
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        configureNavigation()
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationBar.sizeToFit()
    }
    
    // MARK: - Configure
    private func configure() {
//        NotificationCenter.default.rx
//            .notification(UIDevice.orientationDidChangeNotification)
//            .delay(.milliseconds(200), scheduler: MainScheduler.instance)
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [self] _ in
//                self.configureNavigation()
//            }).disposed(by: disposeBag)
    }
    
//    private func configureNavigation() {
//        if UIDevice.current.orientation == .landscapeLeft ||
//            UIDevice.current.orientation == .landscapeRight {
//            navigationBar.prefersLargeTitles = false
//            navigationItem.largeTitleDisplayMode = .never
//        } else {
//            navigationBar.prefersLargeTitles = true
//            navigationItem.largeTitleDisplayMode = .always
//        }
//        navigationBar.sizeToFit()
//    }
}
