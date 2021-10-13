//
//  Button.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 07/04/2021.
//

import UIKit

@IBDesignable class Button: UIButton {
    // MARK: - Enum
    enum ButtonState {
        case normal
        case disabled
    }
    
    enum Style {
        case primary
        case secondary
    }
    
    // MARK: - Properties
    var disabledBackgroundColor: UIColor?
    var defaultBackgroundColor: UIColor? {
        didSet {
            backgroundColor = defaultBackgroundColor
        }
    }
    
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
        layer.cornerRadius = 10
        
        disabledBackgroundColor = ._secondarySystemFill
        titleLabel?.font = UIFont.getFont(style: .subheadline, weight: .bold)
    }
    
    // MARK: -
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
    // MARK: - State
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                if let color = defaultBackgroundColor {
                    self.backgroundColor = color
                }
            } else {
                if let color = disabledBackgroundColor {
                    self.backgroundColor = color
                }
            }
        }
    }
    
    // MARK: Style
    func setStyle(_ style: Style) {
        switch style {
        case .primary:
            defaultBackgroundColor = SwiftyAssets.UIColors.primary
            setTitleColor(.white, for: .normal)
            contentEdgeInsets = .init(top: 12, left: 20, bottom: 12, right: 20)
        case .secondary:
            defaultBackgroundColor = .clear
            setTitleColor(SwiftyAssets.UIColors.primary, for: .normal)
            contentEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    func setBackgroundColor(_ color: UIColor?, for state: ButtonState) {
        switch state {
        case .disabled:
            disabledBackgroundColor = color
        case .normal:
            defaultBackgroundColor = color
        }
    }
}
