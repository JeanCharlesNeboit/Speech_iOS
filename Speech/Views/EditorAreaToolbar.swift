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
    
    @IBOutlet weak var clearButton: UIButton! {
        didSet {
            clearButton.setTitle(SwiftyAssets.Strings.generic_clear, for: .normal)
            clearButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.onClearDidTap?()
                }).disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.setImage(SwiftyAssets.Images.play_circle.withRenderingMode(.alwaysTemplate), for: .normal)
            playButton.tintColor = UIColor.systemBlue
        }
    }
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.setTitle(SwiftyAssets.Strings.generic_save, for: .normal)
            saveButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.onSaveDidTap?()
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Properties
    var onClearDidTap: (() -> Void)?
    var onSaveDidTap: (() -> Void)?
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 80)
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        addShadow(color: .darkGray, opacity: 0.20, offset: .zero, radius: 4)
    }
}
