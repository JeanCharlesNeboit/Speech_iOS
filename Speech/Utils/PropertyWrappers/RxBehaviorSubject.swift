//
//  RxBehaviorSubject.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 18/04/2021.
//

import Foundation
import RxSwift

@propertyWrapper
public class RxBehaviorSubject<T> {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var behaviorSubject: BehaviorSubject<T>
    private var value: T

    public var wrappedValue: T {
        get {
            value
        } set {
            value = newValue
            behaviorSubject.onNext(newValue)
        }
    }
    
    public var projectedValue: BehaviorSubject<T> {
        behaviorSubject
    }

    // MARK: - Initialization
    public init(wrappedValue: T) {
        self.value = wrappedValue
        self.behaviorSubject = BehaviorSubject<T>(value: wrappedValue)
        behaviorSubject.subscribe(onNext: { [weak self] newValue in
            self?.value = newValue
        }).disposed(by: disposeBag)
    }
}
