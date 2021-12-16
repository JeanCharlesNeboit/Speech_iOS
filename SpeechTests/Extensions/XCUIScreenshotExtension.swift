//
//  XCUIScreenshotExtension.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 01/09/2021.
//

import XCTest

extension XCUIScreenshot {
    func saveScreenshot(folder: URL, forName name: String) {
        image.save(folder: folder, forName: name)
    }
}
