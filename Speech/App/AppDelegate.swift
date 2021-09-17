//
//  AppDelegate.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import StoreKit
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
        
        // Firebase
        FirebaseService.configure()
        
        // AVAudioSession
        AVAudioSessionService.default.set(category: .playback, mode: .spokenAudio)
        
        // SwiftyKit
        SwiftyUIView.DefaultCornerRadius = 10
        
        // SKStoreReviewController
        #warning("Use NotificationCenter instead")
//        DefaultsStorage.$savedMessagesCount
//            .filter { $0 > 0 && $0 % 1 == 0 }
//            .subscribe(onNext: { _ in
//                SKStoreReviewController.requestReview()
//            }).disposed(by: disposeBag)
        
        // Window
        window = UIWindow()
        window?.set(rootViewController: LoadViewController())
//        window?.set(rootViewController: UIViewController.main)
        
        return true
    }
}
