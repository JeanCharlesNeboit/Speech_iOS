//
//  EditorAreaViewControllerTests.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import XCTest
@testable import Speech

class EditorAreaViewControllerTests: AbstractTestViewController<EditorAreaViewController> {
    // MARK: - Properties
    private var textView: TextView {
        sut.textView
    }
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = EditorAreaViewController()
    }
    
    // MARK: - Tests
    func testShowWelcome() {
        // Given
        DefaultsStorage.welcomeDone = false
        
        // When
        showViewController()
        let nav = sut.presentedViewController as! NavigationController
        
        // Then
        XCTAssertTrue(nav.topViewController is WelcomeViewController)
    }
    
    func testNavigationBar() {
        // Given
        let navigationItem = sut.navigationItem
        
        // When
        showViewController()
        
        // Then
//        XCTAssertEqual(navigationItem.leftBarButtonItem?.image?.pngData(), SwiftyAssets.UIImages.line_horizontal_3_circle.pngData())
        XCTAssertEqual(navigationItem.title, Bundle.main.displayName)
    }
    
    func testTextView() {
        // Given
        
        // When
        showViewController()
        
        // Then
        XCTAssertTrue(textView.isScrollEnabled)
        XCTAssertTrue(textView.alwaysBounceVertical)
    }
}
