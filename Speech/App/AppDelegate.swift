//
//  AppDelegate.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import SwiftyKit
import AppTrackingTransparency

class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Realm
        RealmMigrator.setDefaultConfiguration()
        RealmService.default.printDatabaseFilePath()
        
        // Firebase
        FirebaseService.configure()
        
        // AVAudioSession
        AVAudioSessionService.default.set(category: .playback, mode: .spokenAudio)
        
        // SwiftyKit
        SwiftyUIView.DefaultCornerRadius = 10
        
        // Window
        window = UIWindow()
        window?.set(rootViewController: LoadViewController())
//        window?.set(rootViewController: UIViewController.main)
        
        return true
    }
}
