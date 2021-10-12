//
//  LoggerService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/09/2021.
//

import Foundation
import os.log

typealias log = LoggerService

class LoggerService {
    // MARK: - Log
    static func message(_ message: String) {
        os_log("%@", log: .default, type: .info, message)
    }
    
    static func info(_ message: String) {
        self.message("ℹ️ \(message)")
    }
    
    // MARK: - Error
    static func error(_ message: String) {
        self.message("‼️ \(message)")
    }
    
    static func error(_ error: Error) {
        self.error(error.localizedDescription)
    }
}
