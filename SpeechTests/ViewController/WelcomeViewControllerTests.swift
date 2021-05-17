//
//  WelcomeViewControllerTests.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 17/05/2021.
//

import XCTest
@testable import Speech

class WelcomeViewControllerTests: AbstractTestViewController<WelcomeViewController> {
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = WelcomeViewController()
    }
    
    // MARK: - Tests
    func testLayout() {
        // Given
        
        // When
        showViewController()
        
        // Then
        XCTAssertEqual(sut.title, SwiftyAssets.Strings.welcome_title)
        XCTAssertEqual(sut.welcomeImageView.image?.pngData(), SwiftyAssets.UIImages.welcome.pngData())
        XCTAssertEqual(sut.sloganLabel.text, SwiftyAssets.Strings.welcome_slogan)
        XCTAssertEqual(sut.descriptionLabel.text, SwiftyAssets.Strings.welcome_description)
        XCTAssertEqual(sut.getStartedButton.titleLabel?.text, SwiftyAssets.Strings.welcome_get_started)
    }
}
