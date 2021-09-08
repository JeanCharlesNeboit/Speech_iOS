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
    
    // MARK: - Properties
    let viewModel = ViewModel()
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        let accessoryView = EditorAreaToolbar.shared
        let keyboardHeight = KeyboardService.shared.keyboardHeight - accessoryView.bounds.height
        accessoryView.configure(safeAreaBottomInset: view.safeAreaInsets.bottom,
                                keyboardHeight: max(0, keyboardHeight))
        return accessoryView
    }
    
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
        showInputAccessoryView()
        
        if !DefaultsStorage.welcomeDone {
            let nav = NavigationController(rootViewController: WelcomeViewController())
            present(nav)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateNavigationItem()
    }
    
    // MARK: - Configure
    override func configure() {
        navigationItem.rightBarButtonItem = settingsBarButtonItem
        listenNotifications()
        
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
    
    private func listenNotifications() {
        NotificationCenter.default.rx
            .notification(.editorAreaSaveText)
            .subscribe(onNext: { [self] _ in
                switch viewModel.onSave() {
                case .success(let text):
                    if DefaultsStorage.saveMessagesQuickly {
                        viewModel.saveQuickly { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success:
                                self.showSuccess(title: SwiftyAssets.Strings.editor_area_successfully_saved_title,
                                                 message: SwiftyAssets.Strings.editor_area_successfully_saved_body)
                            case .failure:
                                self.showError(title: SwiftyAssets.Strings.editor_area_not_successfully_saved_title,
                                                message: SwiftyAssets.Strings.editor_area_not_successfully_saved_body)
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
            .notification(.editorAreaStartSpeaking)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.startSpeaking(keyboardLanguage: self.textView.textInputMode?.primaryLanguage) { result in
                    if case .failure(let error) = result {
                        self.showError(title: error.title, message: error.body)
                    }
                }
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
    
    // MARK: -
    private func showInputAccessoryView() {
        becomeFirstResponder()
    }
}

extension EditorAreaViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        showInputAccessoryView()
    }
}
