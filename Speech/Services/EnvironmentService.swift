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
    
    var isDev: Bool {
        #if DEV
        return true
        #else
        return false
        #endif
    }
    
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
    
    var additionalName: String {
        #if DEBUG
        return "👨‍💻"
        #elseif BETA
        return "👩‍🔬"
        #elseif RELEASE
        return "📱"
        #else
        return nil
        #endif
    }
}
