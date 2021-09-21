//
//  RealmServiceTests.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 16/09/2021.
//

import XCTest
import RxSwift
@testable import Speech

class RealmServiceTests: RealmTestCase {
    // MARK: - Tests
    // Messages
    func testSaveMessage() {
        // Given
        let disposeBag = DisposeBag()
        let notificationRaiseExpectation = XCTestExpectation()
        let savedMessagesCount = DefaultsStorage.savedMessagesCount
        let message = Message(text: "Apple")
        
        // When
        NotificationCenter.default.rx.notification(.MessageDidSave)
            .subscribe(onNext: { _ in
                notificationRaiseExpectation.fulfill()
            }).disposed(by: disposeBag)
        
        realmService.save(message: message) { _ in }
        
        // Then
        XCTAssertEqual(realmService.allMessagesResult().first?.text, "Apple")
        XCTAssertEqual(DefaultsStorage.savedMessagesCount, savedMessagesCount + 1)
        wait(for: [notificationRaiseExpectation], timeout: 1)
    }
    
    func testAllMessageResult() {
        // Given
        let messages = ["iPhone", "iPad", "Mac"].map { Message(text: $0) }
        
        // When
        realmService.addObjects(messages)
        let result = realmService.allMessagesResult()
        
        // Then
        XCTAssertEqual(result.count, 3)
    }
    
    func testAllMessagesWithoutCategoryResult() {
        // Given
        let category = Speech.Category(name: "Apple Devices")
        let messages = [
            ("iPhone", category),
            ("iPad", category),
            ("Mac", category),
            ("Android", nil)
        ].map { Message(text: $0.0, category: $0.1) }
        
        // When
        realmService.addObjects(messages)
        let result = realmService.allMessagesWithoutCategoryResult()
        
        // Then
        XCTAssertEqual(result.count, 1)
    }
    
    func testAllMessagesWithCategoryResult() {
        // Given
        let category = Speech.Category(name: "Apple Devices")
        let messages = [
            ("iPhone", category),
            ("iPad", category),
            ("Mac", category),
            ("Android", nil)
        ].map { Message(text: $0.0, category: $0.1) }
        
        // When
        realmService.addObjects(messages)
        let categoryResult = realmService.allMessagesWithCategoryResult(category: category)
        let withoutCategoryResult = realmService.allMessagesWithCategoryResult(category: Speech.Category.withoutCategory)
        
        // Then
        XCTAssertEqual(categoryResult.count, 3)
        XCTAssertEqual(withoutCategoryResult.count, 1)
    }
    
    func testDoesMessageAlreadyExist() {
        // Given
        let message = Message(text: "iPhone")
        
        // When
        realmService.addObject(message)
        
        // Then
        XCTAssertTrue(realmService.doesMessageAlreadyExist(text: "iPhone"))
        XCTAssertFalse(realmService.doesMessageAlreadyExist(text: "iPad"))
    }
    
    func testDoesMessageAlreadyExistWithWhitespaces() {
        // Given
        let message = Message(text: "iPhone")
        
        // When
        realmService.addObject(message)
        
        // Then
        XCTAssertTrue(realmService.doesMessageAlreadyExist(text: " iPhone  "))
    }
    
    func testMostUsedMessages() {
        // Given
        let messages = ["iPhone", "iPad", "Mac", "Watch", "TV"].map { Message(text: $0) }
        
        // When
        realmService.addObjects(messages)
        messages.enumerated().forEach { offset, message in
            for _ in 0..<offset {
                message.incrementNumberOfUse()
            }
        }
        
        // Then
        XCTAssertEqual(realmService.mostUsedMessages(limit: 5).map { $0.text }, messages.reversed().map { $0.text })
    }
    
    // Categories
    func testGetCategoriesWithoutParentResult() {
        // Given
        let categories = ["Apple", "Raspberry"].map { Speech.Category(name: $0) }
        
        // When
        realmService.addObjects(categories)
        
        // Then
        XCTAssertEqual(realmService.getCategories(parent: nil).count, 2)
    }
    
    func testGetSubCategoriesResult() {
        // Given
        let fruitCategory = Speech.Category(name: "Fruits")
        let categories = ["Apple", "Raspberry"].map { Speech.Category(name: $0, parentCategory: fruitCategory) }
        
        // When
        realmService.addObject(fruitCategory)
        realmService.addObjects(categories)
        
        // Then
        XCTAssertEqual(realmService.getSubCategoriesResult(parent: fruitCategory).count, 2)
    }
    
    func testMostUsedCategories() {
        // Given
        let categories = ["iPhone", "iPad", "Mac", "Watch", "TV"].map { Speech.Category(name: $0) }
        let messages = ["iPhone 13 Pro", "iPad mini", "Macbook Pro", "Watch SERIES 7", "Apple TV 4K"].map { Message(text: $0) }
        Array(zip(categories, messages)).forEach { $1.category = $0 }
        
        // When
        realmService.addObjects(messages)
        messages.enumerated().forEach { offset, message in
            for _ in 0..<offset {
                message.incrementNumberOfUse()
            }
        }
        
        // Then
        XCTAssertEqual(realmService.mostUsedCategories(limit: 5).map { $0.name }, categories.reversed().map { $0.name })
    }
}
