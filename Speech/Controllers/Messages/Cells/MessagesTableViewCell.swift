//
//  MessageCollectionViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 25/05/2021.
//

import UIKit
import RxSwift

class MessagesTableViewCell: AbstractTableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: - Configure
    func configure(messages: [Message], column: Int) {
        stackView.removeAllArrangedSubviews()
        var views = messages.map { message -> UIView in
            let view: MessageTileView = .loadFromXib()
            view.configure(message: message)
            return view
        }
        
        let missingColumn = column - views.count
        for _ in 0..<missingColumn {
            let clearView = UIView()
            views.append(clearView)
        }

        stackView.addArrangedSubview(views)
        stackView.arrangedSubviews.forEach { view in
            view.width(100)
        }
    }
    
    func updateLayout() {
//        print(bounds.width)
//        print(stackView.frame.width)
    }
}
