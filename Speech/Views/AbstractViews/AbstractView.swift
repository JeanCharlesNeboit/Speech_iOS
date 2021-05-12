//
//  AbstractView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/03/2021.
//

import UIKit
import RxSwift

class AbstractView: UIView {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    func sharedInit() {
        configure()
    }
    
    // MARK: - Configure
    func configure() {
        
    }
}
