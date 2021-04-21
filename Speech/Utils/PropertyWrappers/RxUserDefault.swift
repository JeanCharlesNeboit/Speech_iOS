//
//  RxUserDefault.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 18/04/2021.
//

import Foundation
import SwiftyKit
import RxSwift

@propertyWrapper
public class RxUserDefault<T>: UserDefault<T> {
    // MARK: - Properties
    private var behaviorSubject: BehaviorSubject<T>

    public override var wrappedValue: T {
        didSet {
            behaviorSubject.onNext(wrappedValue)
        }
    }

    public var projectedValue: BehaviorSubject<T> {
        behaviorSubject
    }

    // MARK: - Initialization
    override init(wrappedValue: T, key: String, userDefaults: UserDefaults = UserDefaults.standard) {
        self.behaviorSubject = BehaviorSubject<T>(value: wrappedValue)
        super.init(wrappedValue: wrappedValue, key: key, userDefaults: userDefaults)
    }
}

@propertyWrapper
public class RxRawUserDefault<T>: RawUserDefault<T> where T: RawRepresentable {
    // MARK: - Properties
    private var behaviorSubject: BehaviorSubject<T>

    public override var wrappedValue: T {
        didSet {
            behaviorSubject.onNext(wrappedValue)
        }
    }

    public var projectedValue: BehaviorSubject<T> {
        behaviorSubject
    }

    // MARK: - Initialization
    override init(wrappedValue: T, key: String, userDefaults: UserDefaults = UserDefaults.standard) {
        self.behaviorSubject = BehaviorSubject<T>(value: wrappedValue)
        super.init(wrappedValue: wrappedValue, key: key, userDefaults: userDefaults)
    }
}
