//
//  AbstractViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 25/05/2021.
//

import Foundation
import RxSwift

class AbstractViewModel {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    lazy var realmService = RealmService()
    lazy var environmentService = EnvironmentService()
}
