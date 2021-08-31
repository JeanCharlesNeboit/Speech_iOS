//
//  AbstractXCTestCase.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 31/03/2021.
//

import XCTest
import RealmSwift
@testable import Speech

class AbstractXCTestCase: XCTestCase {
    // MARK: - Properties
    private(set) var window: UIWindow!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
    }
    
    // MARK: -
    func show(viewController: UIViewController, inNav: Bool = true) {
        if inNav && viewController as? UINavigationController == nil {
            window.rootViewController = NavigationController(rootViewController: viewController)
        } else {
            window.rootViewController = viewController
        }
        wait(forSeconds: 1)
    }
    
    func wait(forSeconds seconds: Double) {
//        while true {
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, seconds, false)
//        }
    }
    
    func lock() {
        while true {
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0, true)
        }
    }
}
