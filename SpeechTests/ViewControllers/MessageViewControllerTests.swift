//
//  MessageViewControllerTests.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 31/08/2021.
//

import XCTest
@testable import Speech

class MessageViewControllerTests: AbstractTestViewController<MessageViewController> {
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        
    }
    
    // MARK: - Tests
    func testMessageTrimming() {
        // Given
        sut = MessageViewController(viewModel: .init(mode: .creation(text: "Hello ")))
        
        // When
        showViewController()
        sut.viewModel.onValidate { _ in }
        
        // Then
        let messagesResult = realmService.allMessagesResult()
        XCTAssertEqual(messagesResult.count, 1)
        XCTAssertEqual(messagesResult.first?.text, "Hello")
    }
    
    func testMessageTrimmingOnQuicklySave() {
        
    }
}
