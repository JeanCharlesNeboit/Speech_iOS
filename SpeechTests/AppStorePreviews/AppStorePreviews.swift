//
//  AppStorePreviews.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 31/08/2021.
//
// xcrun simctl status_bar booted override --time 9:41 --operatorName ' ' --cellularMode active --cellularBar 4 --wifiBars 3 --batteryState charged --batteryLevel 100

import XCTest
@testable import Speech

class AppStorePreviews: AbstractTestViewController<UIViewController> {
    // MARK: - Properties
    private let previewsFolder = URL(fileURLWithPath: #file)
             .pathComponents
             .dropLast(3)
             .joined(separator: "/")
             .dropFirst()
             .appending("/AppStorePreviews")
         
     private lazy var previewsFolderURL = {
         URL(string: previewsFolder)!
     }()
    
    // MARK: - Previews
    private func takeScreenshot(name: String) {
        XCUIScreen.main.screenshot().saveScreenshot(folder: previewsFolderURL, forName: name)
    }
    
    func testLoadPreview() {
        // Given
        sut = LoadViewController()
        
        // When
        show(viewController: sut)
        
        // Then
        takeScreenshot(name: "load")
    }
    
    func testWelcomePreview() {
        // Given
        sut = WelcomeViewController()
        
        // When
        show(viewController: sut)
        
        // Then
        takeScreenshot(name: "welcome")
    }
}
