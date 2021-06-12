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
    // MARK: - IBOutlets
    @IBOutlet weak var textView: TextView! {
        didSet {
            textView.placeholder = SwiftyAssets.Strings.editor_area_placeholder
        }
    }
    
    // MARK: - Properties
    private lazy var speechSynthesizerService = SpeechSynthesizerService.shared
    
    override var canBecomeFirstResponder: Bool {
        guard presentedViewController == nil else { return false }
        return true
    }
    
    override var inputAccessoryView: UIView? {
        let accessoryView = EditorAreaToolbar.shared
        let keyboardHeight = KeyboardService.shared.keyboardHeight - accessoryView.bounds.height
        accessoryView.configure(safeAreaBottomInset: view.safeAreaInsets.bottom,
                                keyboardHeight: max(0, keyboardHeight))
        return accessoryView
    }
    
    private lazy var settingsBarButtonItem: UIBarButtonItem = {
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
        
        if !DefaultsStorage.welcomeDone {
            let nav = NavigationController(rootViewController: WelcomeViewController())
            present(nav)
        }
        
        if !isCollapsed {
            navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        } else {
            let messageBarButtonItem = UIBarButtonItem(image: SwiftyAssets.UIImages.line_horizontal_3_circle, style: .plain, target: nil, action: nil)
            messageBarButtonItem.rx.tap
                .subscribe(onNext: { [self] in
                    present(NavigationController(rootViewController: MessageListViewController()), animated: true, completion: nil)
                }).disposed(by: disposeBag)
            navigationItem.leftBarButtonItem = messageBarButtonItem
        }
    }
    
    // MARK: - Configure
    override func configure() {
        navigationItem.rightBarButtonItem = settingsBarButtonItem
        
        RxKeyboard.instance.isHidden
            .filter { $0 == true }
            .delay(.milliseconds(500))
            .drive(onNext: { [self] _ in
                becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        listenNotifications()
        
        DefaultsStorage.$preferredEditorAreaTextFont
            .subscribe(onNext: { [textView] fontStyle in
                textView?.setDynamicFont(style: fontStyle)
            }).disposed(by: disposeBag)
        
        #if DEBUG
        textView.append(text: "Bonjour")
        #endif
    }
    
    private func listenNotifications() {
        NotificationCenter.default.rx
            .notification(.editorAreaClearText)
            .subscribe(onNext: { [textView] _ in
                textView?.clear()
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.editorAreaSaveText)
            .subscribe(onNext: { [self] _ in

                guard let text = self.textView.enteredText else {
                    showEmptyError()
                    return
                }

                guard !realmService.doesMessageAlreadyExist(text: text) else {
                    showWarning(title: SwiftyAssets.Strings.editor_area_duplication_title,
                                message: SwiftyAssets.Strings.editor_area_duplication_body)
                    return
                }

                let message = Message(emoji: nil, text: text)
                if DefaultsStorage.saveMessagesQuickly {
                    #warning("Manage notifications with MessageViewController too")
                    realmService.addObject(message, completion: { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success:
                            self.showSuccess(title: SwiftyAssets.Strings.editor_area_successfully_saved_title,
                                             message: SwiftyAssets.Strings.editor_area_successfully_saved_body)
                        case .failure:
                            self.showError(title: SwiftyAssets.Strings.editor_area_not_successfully_saved_title,
                                             message: SwiftyAssets.Strings.editor_area_not_successfully_saved_body)
                        }
                    })
                } else {
                    let destination = NavigationController(rootViewController: MessageViewController(message: message))
                    present(destination, animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.editorAreaAppendText)
            .subscribe(onNext: { [textView] notification in
                if let text = notification.object as? String {
                    textView?.append(text: text)
                }
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.editorAreaStartSpeaking)
            .subscribe(onNext: { [self] _ in
                guard let text = self.textView.enteredText else {
                    showEmptyError()
                    return
                }
                
                var selectedText: String?
                if let selectedTextRange = textView.selectedTextRange {
                    selectedText = textView.text(in: selectedTextRange)
                }
                
                var textToSpeech = text
                if let selectedText = selectedText {
                    textToSpeech = selectedText
                }
                
//                let language = textView.textInputMode?.primaryLanguage
                speechSynthesizerService.startSpeaking(text: textToSpeech, voice: nil)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Errors
    private func showEmptyError() {
        // textView.resignFirstResponder()
        showError(title: SwiftyAssets.Strings.editor_area_empty_text_on_save_title,
                  message: SwiftyAssets.Strings.editor_area_empty_text_on_save_body)
    }
}

extension EditorAreaViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if canBecomeFirstResponder {
            becomeFirstResponder()
        }
    }
}
