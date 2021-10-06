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
        DefaultsStorage.onboardingDone = true
        DefaultsStorage.replaceTextWhenMessageSelected = true
        sut = EditorAreaViewController()
    }
    
    // MARK: - Tests
    func testShowWelcome() {
        // Given
        DefaultsStorage.onboardingDone = false
        
        // When
        showViewController()
        let nav = sut.presentedViewController as! NavigationController
        
        // Then
        XCTAssertFalse(sut.isFirstResponder)
        XCTAssertTrue(nav.topViewController is WelcomeViewController)
    }
    
    // MARK: NavigationBar
    func testNavigationBar() {
        // Given
        let navigationItem = sut.navigationItem
        
        // When
        showViewController()
        
        // Then
        let leftBarButtonItem = UIDevice.current.isPad ? nil : SwiftyAssets.UIImages.line_horizontal_3_circle
        XCTAssertEqual(navigationItem.leftBarButtonItem?.image, leftBarButtonItem)
        
        XCTAssertEqual(navigationItem.title, Bundle.main.displayName)
        XCTAssertEqual(navigationItem.rightBarButtonItem?.image, SwiftyAssets.UIImages.gearshape)
    }
      
    // MARK: TextView
    func testTextView() {
        // Given
        
        // When
        showViewController()
        
        // Then
        XCTAssertTrue(textView.isScrollEnabled)
        XCTAssertTrue(textView.alwaysBounceVertical)
        XCTAssertTrue(textView.isPlaceholderActive)
        XCTAssertEqual(textView.text, SwiftyAssets.Strings.editor_area_placeholder)
        XCTAssertEqual(textView.textColor, .placeholder)
    }
    
    func testTextViewWithText() {
        // Given
        
        // When
        showViewController()
        textView.text = "Hello Tim !"
        wait(forSeconds: 1)
        
        // Then
        XCTAssertFalse(textView.isPlaceholderActive)
        XCTAssertEqual(sut.viewModel.text, textView.text)
        XCTAssertEqual(textView.textColor, .text)
    }
    
    func testEditorAreaAppendTextNotificationWithReplaceFeature() {
        // Given
        let message = Message(text: "Apple")
        let messageViewModel = MessageListViewModel(category: nil)
        
        // When
        showViewController()
        sut.viewModel.text = "Big Brother"
        messageViewModel.onTap(message: message)
        
        // Then
        XCTAssertEqual(textView.text, "Apple")
    }
    
    func testEditorAreaAppendTextNotification() {
        // Given
        DefaultsStorage.replaceTextWhenMessageSelected = false
        let message = Message(text: "Apple")
        let messageViewModel = MessageListViewModel(category: nil)
        
        // When
        showViewController()
        messageViewModel.onTap(message: message)
        
        // Then
        XCTAssertEqual(textView.text, "Apple")
    }
    
    func testEditorAreaAppendTextNotificationWithNotEmptyTextView() {
        // Given
        DefaultsStorage.replaceTextWhenMessageSelected = false
        let message = Message(text: "World !")
        let messageViewModel = MessageListViewModel(category: nil)
        
        // When
        showViewController()
        sut.viewModel.text = "Hello"
        messageViewModel.onTap(message: message)
        
        // Then
        XCTAssertEqual(textView.text, "Hello World !")
    }
}
