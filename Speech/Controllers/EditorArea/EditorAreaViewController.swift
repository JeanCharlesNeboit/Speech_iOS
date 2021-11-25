//
//  EditorAreaViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import SwiftyKit
import SwiftMessages
import RxSwift
import RxKeyboard

class EditorAreaViewController: AbstractViewController {
    typealias ViewModel = EditorAreaViewModel
    
    // MARK: - IBOutlets
    @IBOutlet weak var textView: TextView! {
        didSet {
            textView.placeholder = SwiftyAssets.Strings.editor_area_placeholder
        }
    }
    @IBOutlet weak var toolbarContainerView: UIStackView! {
        didSet {
            toolbarContainerView.addArrangedSubview(toolbar)
        }
    }
    @IBOutlet weak var toolbarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    let viewModel = ViewModel()
    
    private lazy var toolbar: EditorAreaToolbar = .loadFromXib()
    
    lazy var settingsBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: SwiftyAssets.UIImages.gearshape, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            self.present(NavigationController(rootViewController: SettingsViewController()))
        }).disposed(by: disposeBag)
        return button
    }()
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = Bundle.main.displayName
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationItem()
        if !DefaultsStorage.onboardingDone {
            let nav = NavigationController(rootViewController: WelcomeViewController())
            present(nav)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateNavigationItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let ratio: CGFloat = view.bounds.height/view.bounds.width <= 4/3 ? 0.5 : 0.8
        self.toolbarWidthConstraint.constant = self.view.bounds.width * ratio
    }
    
    // MARK: - Configure
    override func configure() {
        navigationItem.rightBarButtonItem = settingsBarButtonItem
        
        listenNotifications()
        listenKeyboard()
        
        viewModel.$text.subscribe(onNext: { [weak self] text in
            self?.textView.text = text
        }).disposed(by: disposeBag)
        
        textView.rx.text.filter { [weak self] _ in
            !(self?.textView.isPlaceholderActive ?? true)
        }.subscribe(onNext: { [weak self] text in
            self?.viewModel.text = text
        }).disposed(by: disposeBag)
        
        DefaultsStorage.$preferredEditorAreaTextFont
            .subscribe(onNext: { [textView] fontStyle in
                textView?.setDynamicFont(style: fontStyle)
            }).disposed(by: disposeBag)
    }
    
    func updateNavigationItem() {
        if !isCollapsed {
            navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        } else {
            let messageBarButtonItem = UIBarButtonItem(image: SwiftyAssets.UIImages.line_horizontal_3_circle, style: .plain, target: nil, action: nil)
            messageBarButtonItem.rx.tap
                .subscribe(onNext: { [self] in
                    present(NavigationController(rootViewController: MessageListViewController()))
                }).disposed(by: disposeBag)
            navigationItem.leftBarButtonItem = messageBarButtonItem
        }
    }
    
    private func listenNotifications() {
        NotificationCenter.default.rx
            .notification(.EditorAreaSaveText)
            .subscribe(onNext: { [self] _ in
                switch viewModel.canMessageBeSaved(text: viewModel.text) {
                case .success(let text):
                    if DefaultsStorage.saveMessagesQuickly {
                        viewModel.saveQuickly { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success:
                                self.showSuccess(title: SwiftyAssets.Strings.editor_area_successfully_saved_title,
                                                 message: SwiftyAssets.Strings.editor_area_successfully_saved_body)
                            case .failure:
                                self.showError(title: SwiftyAssets.Strings.error_not_successfully_saved_title,
                                                message: SwiftyAssets.Strings.error_not_successfully_saved_body)
                            }
                        }
                    } else {
                        let viewModel = MessageViewModel(mode: .creation(text: text))
                        let destination = NavigationController(rootViewController: MessageViewController(viewModel: viewModel))
                        present(destination)
                    }
                case .failure(let error):
                    self.showError(title: error.title, message: error.body)
                }
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.EditorAreaStartSpeaking)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.startSpeaking(keyboardLanguage: self.textView.textInputMode?.primaryLanguage) { result in
                    if case .failure(let error) = result {
                        self.showError(title: error.title, message: error.body)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func listenKeyboard() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil).subscribe(onNext: { [unowned self] notification in
            animateWithKeyboard(notification: notification) { [unowned self] keyboardFrame in
                self.toolbarBottomConstraint.constant = 20 + keyboardFrame.height - view.safeAreaInsets.bottom
            }
        }).disposed(by: disposeBag)
            
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil).subscribe(onNext: { [unowned self] notification in
            animateWithKeyboard(notification: notification) { [unowned self] _ in
                self.toolbarBottomConstraint.constant = 20
            }
        }).disposed(by: disposeBag)
    }
}
