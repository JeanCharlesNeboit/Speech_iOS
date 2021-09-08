//
//  XCUIScreenshotExtension.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 01/09/2021.
//

import XCTest

extension XCUIScreenshot {
    func saveScreenshot(folder: URL, forName name: String) {
        let localeIdentifier = NSLocale.current.identifier
//        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return }
//        var url = folder.appendingPathComponent(appName, isDirectory: true)
//        url.appendPathComponent(localeIdentifier, isDirectory: true)
        
        var url = folder.appendingPathComponent(localeIdentifier, isDirectory: true)
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.absoluteString) {
            try! fileManager.createDirectory(atPath: url.absoluteString, withIntermediateDirectories: true, attributes: nil)
        }
        
        let deviceName = UIDevice.current.name.replacingOccurrences(of: " ", with: "_")
        url.appendPathComponent("\(name)_\(deviceName).jpg")
        
        let fileURL = URL(fileURLWithPath: url.absoluteString)
        
        save(in: fileURL)
    }
    
    private func save(in url: URL) {
        try! image.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomicWrite)
    }
}
