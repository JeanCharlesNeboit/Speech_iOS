//
//  EnvironmentService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/07/2021.
//

import Foundation

class EnvironmentService {
    // MARK: - Properties
    lazy var environment: [String: String] = ProcessInfo.processInfo.environment
    
    func isDev() -> Bool {
        #if DEV
        return true
        #else
        return false
        #endif
    }
    
    func isDebug() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    func isTest() -> Bool {
        #if DEBUG
        return environment["XCTestConfigurationFilePath"] != nil
        #else
        return false
        #endif
    }
}
