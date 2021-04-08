//
//  Button.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 07/04/2021.
//

import UIKit

@IBDesignable class Button: UIButton {
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        contentEdgeInsets = .init(top: 12, left: 20, bottom: 12, right: 20)
        layer.cornerRadius = 10
        
        backgroundColor = SwiftyAssets.UIColors.primary
        titleLabel?.font = UIFont.getFont(style: .subheadline, weight: .bold)
        setTitleColor(.white, for: .normal)
    }
    
    // MARK: -
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
}
