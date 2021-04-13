//
//  EditorAreaToolbar.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/03/2021.
//

import UIKit
import SwiftyKit

class EditorAreaToolbar: AbstractView {
    // MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.layer.cornerRadius = 20
            contentView.clipsToBounds = true
        }
    }
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var clearButton: UIButton! {
        didSet {
            clearButton.setTitle(SwiftyAssets.Strings.generic_clear, for: .normal)
            clearButton.rx.tap
                .subscribe(onNext: { _ in
                    NotificationCenter.default.post(name: Notification.Name.editorAreaClearText, object: nil)
                }).disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var speechSynthetiserActionStackView: UIStackView!
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.setTitle(SwiftyAssets.Strings.generic_save, for: .normal)
            saveButton.rx.tap
                .subscribe(onNext: { _ in
                    NotificationCenter.default.post(name: Notification.Name.editorAreaSaveText, object: nil)
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Properties
    static let shared: EditorAreaToolbar = .loadFromXib()
    
    private lazy var stopButton: UIButton = {
        let stopButton = UIButton()
        stopButton.setImage(SwiftyAssets.Images.stop_circle.withRenderingMode(.alwaysTemplate), for: .normal)
        stopButton.rx.tap
            .subscribe(onNext: { _ in
                NotificationCenter.default.post(name: Notification.Name.editorAreaStopSpeaking, object: nil)
            }).disposed(by: disposeBag)
        return stopButton
    }()
    
    private lazy var pauseButton: UIButton = {
        let pauseButton = UIButton()
        pauseButton.setImage(SwiftyAssets.Images.pause_circle.withRenderingMode(.alwaysTemplate), for: .normal)
        pauseButton.rx.tap
            .subscribe(onNext: { _ in
                NotificationCenter.default.post(name: Notification.Name.editorAreaPauseSpeaking, object: nil)
            }).disposed(by: disposeBag)
        return pauseButton
    }()
    
    private lazy var playButton: UIButton = {
        let playButton = UIButton()
        playButton.setImage(SwiftyAssets.Images.play_circle.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.rx.tap
            .subscribe(onNext: { _ in
                if SpeechSynthesizerService.shared.state == .pause {
                    NotificationCenter.default.post(name: Notification.Name.editorAreaContinueSpeaking, object: nil)
                } else {
                    NotificationCenter.default.post(name: Notification.Name.editorAreaStartSpeaking, object: nil)
                }
            }).disposed(by: disposeBag)
        return playButton
    }()
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: contentViewHeightConstraint.constant)
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        listenSpeechSynthesizerState()
    }
    
    // MARK: - Configure
    private func configure() {
        addShadow(color: .black, opacity: 0.2, offset: .zero, radius: 4)
    }
    
    func configure(safeAreaBottomInset: CGFloat, keyboardHeight: CGFloat) {
        var bottomConstant: CGFloat = 20
        if keyboardHeight == 0,
           safeAreaBottomInset > 0 {
            bottomConstant = 0
        }
        contentViewBottomConstraint.constant = bottomConstant
    }
    
    // MARK: - SpeechSynthesizerState
    private func listenSpeechSynthesizerState() {
        SpeechSynthesizerService.shared.stateBehaviorSubject
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                let actionButtons: [UIButton]
                
                switch state {
                case .idle:
                    actionButtons = [self.playButton]
                case .speak:
                    actionButtons = [self.stopButton, self.pauseButton]
                case .pause:
                    actionButtons = [self.stopButton, self.playButton]
                }
                
                self.speechSynthetiserActionStackView.removeAllArrangedSubviews()
                self.speechSynthetiserActionStackView.addArrangedSubview(actionButtons)
            }).disposed(by: disposeBag)
    }
}
