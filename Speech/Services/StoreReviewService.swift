//
//  StoreReviewService.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 22/09/2021.
//

import Foundation
import StoreKit
import RxSwift

class StoreReviewService {
    // MARK: - Properties
    static let `default` = StoreReviewService()
    
    private let disposeBag = DisposeBag()
    private let eachSavedMessage = 10
    
    // MARK: -
    func configure() {
        NotificationCenter.default.rx.notification(.MessageDidSave)
            .map { _ in DefaultsStorage.savedMessagesCount }
            .filter { [unowned self] in $0 > 0 && $0 % self.eachSavedMessage == 0 }
            .subscribe(onNext: { _ in
                SKStoreReviewController.requestReview()
            }).disposed(by: disposeBag)
    }
}
