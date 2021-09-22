//
//  UIViewControllerExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import SafariServices
import TinyConstraints
import SwiftMessages

extension UIViewController {
    static var main: UIViewController {
        let homeViewController = NavigationController(rootViewController: EditorAreaViewController())
        if UIDevice.current.userInterfaceIdiom == .pad {
            let splitViewController = SplitViewController()
            let mainViewController = NavigationController(rootViewController: MessageListViewController())
            let detailsViewController = homeViewController
            splitViewController.configure(main: mainViewController, details: detailsViewController)
            return splitViewController
        } else {
            return homeViewController
        }
    }
}

extension UIViewController {
    // https://www.advancedswift.com/animate-with-ios-keyboard-swift/#keyboardanimationcurveuserinfokey-and-uiviewpropertyanimator
    func animateWithKeyboard(notification: Notification, animations: ((_ keyboardFrame: CGRect) -> Void)?) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        guard let duration = notification.userInfo?[durationKey] as? Double else { return }
        
        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrameValue = notification.userInfo?[frameKey] as? NSValue else { return }
        
        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        guard let curveValue = notification.userInfo?[curveKey] as? Int,
              let curve = UIView.AnimationCurve(rawValue: curveValue) else { return }
        
        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue)
            
            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }
        
        // Start the animation
        animator.startAnimation()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AbstractViewController {
    func showError(title: String?, message: String) {
        showMessageCardView(title: title.strongValue, body: message, theme: .error)
    }
    
    func showWarning(title: String, message: String) {
        showMessageCardView(title: title, body: message, theme: .warning)
    }
    
    func showSuccess(title: String, message: String) {
        showMessageCardView(title: title, body: message, theme: .success)
    }
    
    private func showMessageCardView(title: String,
                                     body: String,
                                     theme: Theme,
                                     duration: SwiftMessages.Duration = .seconds(seconds: 2),
                                     presentationStyle: SwiftMessages.PresentationStyle = .top) {
        
        let cardView: MessageView = .viewFromNib(layout: .cardView)
        cardView.configureTheme(theme)
        cardView.configureContent(title: title, body: body)
        cardView.button?.isHidden = true
        
        var config = SwiftMessages.defaultConfig
        config.keyboardTrackingView = KeyboardTrackingView()
        config.duration = duration
        config.presentationStyle = presentationStyle
        config.presentationContext = .viewController(self)
        
        SwiftMessages.show(config: config, view: cardView)
    }
}

extension UIViewController {
    @discardableResult
    func customPresent(_ vc: UIViewController) -> SwiftMessagesSegue {
        let segue = SwiftMessagesSegue(identifier: nil, source: self, destination: vc)
        segue.interactiveHide = false
        segue.presentationStyle = .center
        segue.dimMode = .blur(style: .regular, alpha: 1, interactive: true)
        segue.containerView.cornerRadius = 20
        segue.messageView.configureDropShadow()
        segue.containment = .background
        segue.perform()
        return segue
    }
    
    func present(_ vc: UIViewController) {
        if !(splitViewController?.isCollapsed ?? true) {
            vc.modalPresentationStyle = .formSheet
        } else {
            vc.modalPresentationStyle = .fullScreen
        }
        
//        // Important because viewWillAppear not called on iOS 13 modal
//        if let delegate = self as? UIAdaptivePresentationControllerDelegate {
//            vc.presentationController?.delegate = delegate
//        }
        
        present(vc, animated: true, completion: nil)
    }
}

extension UIViewController {
    func openSafari(urlString: String, inApp: Bool = false) {
        guard let url = URL(string: urlString) else { return }
        if inApp {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(url)
        }
    }
}
