//
//  AppDelegate.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import AppTrackingTransparency
import SwiftyKit
import RxSwift

class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Realm
        RealmMigrator.setDefaultConfiguration()
        RealmService.default.printDatabaseFilePath()
        
//        if !DefaultsStorage.coreDataMigrationDone {
            RealmService.default.performCoreDataToRealmMigration()
//        }
        
        // DefaultsStorage
        DefaultsStorage.configure()
        
        // Firebase
        FirebaseService.default.configure()
        
        // AVAudioSession
        AVAudioSessionService.default.set(category: .playback, mode: .spokenAudio)
        
        // StoreReviewService
        StoreReviewService.default.configure()
        
        // SwiftyKit
        SwiftyUIView.DefaultCornerRadius = 10
        
        // Window
        window = UIWindow()
        window?.set(rootViewController: LoadViewController())
        
        return true
    }
}
