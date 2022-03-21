//
//  FirebaseService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 09/04/2021.
//

import SwiftyKit
import Firebase
import FirebaseCrashlytics
import RxSwift

class FirebaseService {
    // MARK: - Properties
    static let `default` = FirebaseService()
    private let disposeBag = DisposeBag()
    
    // MARK: - Configure
    func configure() {
        FirebaseApp.configure()
        DefaultsStorage.$enableCrashlyticsCollection.subscribe(onNext: { [weak self] enabled in
            self?.setCrashlyticsCollection(enabled: enabled)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Crashlytics
    private func setCrashlyticsCollection(enabled: Bool) {
        log.info(enabled ? "Crashlytics enable" : "Crashlytics disable")
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(enabled)
    }
}
