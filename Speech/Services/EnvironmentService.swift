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
    
    var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    var isRelease: Bool {
        #if RELEASE
        return true
        #else
        return false
        #endif
    }
    
    var isTest: Bool {
        #if DEBUG
        return environment["XCTestConfigurationFilePath"] != nil
        #else
        return false
        #endif
    }
    
    var configurationName: String? {
        #if DEBUG
        return "debug"
        #elseif BETA
        return "beta"
        #else
        return nil
        #endif
    }
}
