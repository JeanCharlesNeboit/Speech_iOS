//
//  ViewControllerTests.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 10/05/2021.
//

import XCTest
@testable import Speech

class ViewControllerTests: AbstractXCTestCase {
    // MARK: - Tests
    func testMainViewController() {
        // Given
        
        // When
        show(viewController: UIViewController.main)
        
        // Then
        if UIDevice.current.userInterfaceIdiom == .pad {
            let splitVC = window.rootViewController as? SplitViewController
            let mainNav = splitVC?.viewControllers[safe: 1] as? NavigationController
            let detailsNav = splitVC?.viewControllers.first as? NavigationController
            XCTAssertTrue(mainNav?.topViewController is EditorAreaViewController)
            XCTAssertTrue(detailsNav?.topViewController is MessageListViewController)
        } else {
            let nav = window.rootViewController as? NavigationController
            XCTAssertTrue(nav?.topViewController is EditorAreaViewController)
        }
    }
}
