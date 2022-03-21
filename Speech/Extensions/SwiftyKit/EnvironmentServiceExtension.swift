//
//  EnvironmentService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/07/2021.
//

import Foundation
import SwiftyKit

extension EnvironmentService {
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
