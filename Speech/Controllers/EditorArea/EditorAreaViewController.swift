//
//  EditorAreaViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import SwiftyKit
import SwiftMessages

class EditorAreaViewController: AbstractViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var textView: TextView! {
        didSet {
            textView.placeholder = SwiftyAssets.Strings.editor_area_placeholder
        }
    }
    
    // MARK: - Properties
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return editorAreaToolbar
    }
    
    private lazy var editorAreaToolbar: EditorAreaToolbar = {
        let toolbar: EditorAreaToolbar = .loadFromXib()
        toolbar.onClearDidTap = {
            self.textView.clear()
        }
        toolbar.onSaveDidTap = {
            guard let text = self.textView.enteredText else {
                self.showError(title: SwiftyAssets.Strings.editor_area_empty_text_on_save_title,
                               message: SwiftyAssets.Strings.editor_area_empty_text_on_save_body)
                return
            }
            let message = Message(text: text)
            self.realmService.addObject(message)
        }
        return toolbar
    }()
    
    private lazy var settingsBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: SwiftyAssets.Images.gearshape, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            let destination = NavigationController(rootViewController: SettingsViewController())
            let segue = SwiftMessagesSegue(identifier: nil, source: self, destination: destination)
            
            segue.interactiveHide = false
            segue.presentationStyle = .center
            segue.dimMode = .blur(style: .dark, alpha: 1, interactive: false)
            segue.containerView.cornerRadius = 20
//            segue.messageView.collapseLayoutMarginAdditions = true
            segue.containment = .background
            
            segue.perform()
        }).disposed(by: disposeBag)
        return button
    }()
    
    // MARK: - Configure
    override func configure() {
        title = Bundle.main.displayName
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.rightBarButtonItem = settingsBarButtonItem
        listenNotifications()
    }
    
    private func listenNotifications() {
        NotificationCenter.default.rx
            .notification(.editorAreaAppendText)
            .subscribe(onNext: { [textView] notification in
                if let text = notification.object as? String {
                    textView?.append(text: text)
                }
            }).disposed(by: disposeBag)
    }
}
