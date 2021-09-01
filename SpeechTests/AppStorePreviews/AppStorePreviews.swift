//
//  AppStorePreviews.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 31/08/2021.
//

import XCTest

class AppStorePreviews: AbstractXCTestCase {
    // MARK: - Previews
    func testWelcomePreview() {
        let app = XCUIApplication()
        app.launch()
        
        lock()
    }
}
