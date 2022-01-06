//
//  UIDeviceExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/08/2021.
//

import UIKit

extension UIDevice {
    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    var info: String {
        [
            "System Name: \(systemName) \(systemVersion)",
            "Device: \(model)",
            "Model: \(modelName)"
        ].joined(separator: "\n")
    }
}
