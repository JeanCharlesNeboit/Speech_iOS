//
//  AbstractXCTestCase.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 31/03/2021.
//

import XCTest
@testable import Speech

class AbstractXCTestCase: XCTestCase {
    // MARK: -
    func show(viewController: UIViewController) {
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    func lock(forSeconds seconds: Double) {
        while true {
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, seconds, true)
        }
    }
}
