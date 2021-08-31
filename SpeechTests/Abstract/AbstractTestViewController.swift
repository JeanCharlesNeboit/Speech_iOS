//
//  AbstractTestViewController.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 17/05/2021.
//

import XCTest
@testable import Speech

class AbstractTestViewController<T: UIViewController>: RealmTestCase {
    // MARK: - Properties
    var sut: T!
    
    // MARK: - Lifecycle
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Sut
    func showViewController(inNav: Bool = true) {
        show(viewController: sut, inNav: inNav)
    }
}
