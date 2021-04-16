//
//  InputMessageStackView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 15/04/2021.
//

import UIKit
import SwiftyKit
import RxSwift

class InputMessageStackView: UIStackView {
    // MARK: - Enum
    enum MessageType {
        case warning
        case error
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.sizeToFit()
        messageLabel.numberOfLines = 0
        messageLabel.setDynamicFont(style: .footnote, weight: .semibold)
        return messageLabel
    }()
    
    var type = BehaviorSubject<MessageType>(value: .error)
    var message = BehaviorSubject<String?>(value: nil)
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        configure()
    }
    
    // MARK: - Configure
    private func configure() {
        addArrangedSubview([messageLabel])
        
        message.subscribe(onNext: { [weak self] message in
            self?.isHidden = message == nil
            self?.messageLabel.text = message
        }).disposed(by: disposeBag)

        type.subscribe(onNext: { [weak self] type in
            let textColor: UIColor
            switch type {
            case .warning:
                textColor = SwiftyAssets.UIColors.warning
            case .error:
                textColor = SwiftyAssets.UIColors.error
            }
            self?.messageLabel.textColor = textColor
        }).disposed(by: disposeBag)
    }
}
