//
//  EditorAreaToolbar.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/03/2021.
//

import UIKit

class EditorAreaToolbar: AbstractView {
    // MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView!
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
    
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.setImage(SwiftyAssets.Images.play_circle.withRenderingMode(.alwaysTemplate), for: .normal)
            playButton.rx.tap
                .subscribe(onNext: { _ in
                    NotificationCenter.default.post(name: Notification.Name.editorAreaStartSpeaking, object: nil)
                }).disposed(by: disposeBag)
        }
    }
    
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
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: contentViewHeightConstraint.constant)
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        addShadow(color: .darkGray, opacity: 0.20, offset: .zero, radius: 4)
    }
    
    // MARK: - Configure
    func configure(safeAreaBottomInset: CGFloat) {
        let bottomConstant: CGFloat = safeAreaBottomInset > 0 ? 0 : 20
        contentViewBottomConstraint.constant = bottomConstant
    }
}
