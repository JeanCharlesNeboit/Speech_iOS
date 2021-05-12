//
//  EditorAreaViewControllerTests.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import XCTest
@testable import Speech

class EditorAreaViewControllerTests: AbstractXCTestCase {
    // MARK: - Properties
    private var sut: EditorAreaViewController!
    private var textView: TextView {
        sut.textView
    }
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = EditorAreaViewController()
    }
    
    // MARK: - Tests
    func testNavigationBar() {
        // Given
        let navigationItem = sut.navigationItem
        
        // When
        show(viewController: sut)
        
        // Then
//        XCTAssertEqual(navigationItem.leftBarButtonItem?.image?.pngData(), SwiftyAssets.UIImages.line_horizontal_3_circle.pngData())
        XCTAssertEqual(navigationItem.title, Bundle.main.displayName)
    }
    
    func testTextView() {
        // Given
        
        // When
        show(viewController: sut)
        
        // Then
        XCTAssertTrue(textView.isScrollEnabled)
        XCTAssertTrue(textView.alwaysBounceVertical)
    }
}
