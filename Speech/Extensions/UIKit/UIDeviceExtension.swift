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
}
