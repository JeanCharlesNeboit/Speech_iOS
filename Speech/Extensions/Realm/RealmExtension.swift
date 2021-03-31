//
//  RealmExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import Foundation
import RealmSwift

extension Realm {
    func printFilePath() {
        guard let path = configuration.fileURL?.path else { return }
        NSLog("📁 Realm Path: \(path)")
    }
}
