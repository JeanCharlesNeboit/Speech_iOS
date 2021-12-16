//
//  UIImageExtension.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 09/12/2021.
//

import UIKit

extension UIImage {
    func save(folder: URL, forName name: String) {
        let localeIdentifier = NSLocale.current.identifier
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
        try! jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomicWrite)
    }
}
