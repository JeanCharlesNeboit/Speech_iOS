//
//  main.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 31/03/2021.
//

import UIKit

let appDelegateClass: AnyClass = NSClassFromString("SpeechTests.TestAppDelegate") ?? AppDelegate.self
let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
