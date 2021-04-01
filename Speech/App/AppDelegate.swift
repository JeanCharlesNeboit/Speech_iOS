//
//  AppDelegate.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import SwiftyKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.set(rootViewController: UIViewController.main)
        
        RealmMigrator.setDefaultConfiguration()
        RealmService.default.printDatabaseFilePath()
        AVAudioSessionService.default.set(category: .playback, mode: .spokenAudio)
        
        return true
    }
}
