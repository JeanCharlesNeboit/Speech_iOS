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
        return true
    }
    
    override var inputAccessoryView: UIView? {
        let accessoryView = EditorAreaToolbar.shared
        accessoryView.configure(safeAreaBottomInset: view.safeAreaInsets.bottom)
        return accessoryView
    }
    
    private var isCollapsed: Bool {
        splitViewController?.isCollapsed ?? true
    }
    
    private lazy var settingsBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: SwiftyAssets.Images.gearshape, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            let destination = NavigationController(rootViewController: SettingsViewController())
            if self.isCollapsed {
                let segue = SwiftMessagesSegue(identifier: nil, source: self, destination: destination)
                
                segue.interactiveHide = false
                segue.presentationStyle = .center
                segue.dimMode = .blur(style: .dark, alpha: 1, interactive: false)
                segue.containerView.cornerRadius = 20
    //            segue.messageView.collapseLayoutMarginAdditions = true
                segue.containment = .background
                
                segue.perform()
            } else {
                self.present(destination, animated: true, completion: nil)
            }
            
        }).disposed(by: disposeBag)
        return button
    }()
    
    // MARK: - Configure
    override func configure() {
        title = Bundle.main.displayName
        
        if !isCollapsed {
            navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        } else {
            let messageBarButtonItem = UIBarButtonItem(title: "*Messages*", style: .plain, target: nil, action: nil)
            messageBarButtonItem.rx.tap
                .subscribe(onNext: { [self] in
                    present(NavigationController(rootViewController: MessageListViewController()), animated: true, completion: nil)
                }).disposed(by: disposeBag)
            navigationItem.leftBarButtonItem = messageBarButtonItem
        }
        
        navigationItem.rightBarButtonItem = settingsBarButtonItem
        
        RxKeyboard.instance.isHidden
            .filter { $0 == true }
            .delay(.milliseconds(500))
            .drive(onNext: { [self] _ in
                becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        listenNotifications()
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
                let message = Message(text: text)
                realmService.addObject(message)
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
                speechSynthesizerService.startSpeaking(text: text)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Errors
    private func showEmptyError() {
        // textView.resignFirstResponder()
        showError(title: SwiftyAssets.Strings.editor_area_empty_text_on_save_title,
                  message: SwiftyAssets.Strings.editor_area_empty_text_on_save_body)
    }
}
