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
    private var behaviorSubject: BehaviorSubject<T>

    public var wrappedValue: T {
        didSet {
            behaviorSubject.onNext(wrappedValue)
        }
    }
    
    public var projectedValue: BehaviorSubject<T> {
        behaviorSubject
    }

    // MARK: - Initialization
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        self.behaviorSubject = BehaviorSubject<T>(value: wrappedValue)
    }
}

//extension RxBehaviorSubject where T: UserDefault<Any> {
//    override public var projectedValue: BehaviorSubject<T> {
//        behaviorSubject
//    }
//}
