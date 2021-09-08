//
//  MessageCollectionViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 25/05/2021.
//

import UIKit
import RxSwift
import RxGesture

class MessagesTableViewCell: AbstractTableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bottomStackViewConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var tapDisposables = [Disposable]()
    var onCategoryTap: ((Category) -> Void)?
    
    // MARK: - Configure
    func configure(categories: [Category], column: Int, isLast: Bool) {
        tapDisposables.removeAll()
        stackView.removeAllArrangedSubviews()
        
        var views = categories.map { category -> UIView in
//            let view: MessageContentView = .loadFromXib()
            let view: CategoryContentView = .loadFromXib()
            view.configure(category: category)
            view.aspectRatio(1)
            
            let tapDisposable = view.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.onCategoryTap?(category)
                })
            tapDisposables.append(tapDisposable)
            
            return view
        }
        
        let missingColumn = column - views.count
        for _ in 0..<missingColumn {
            let clearView = UIView()
            views.append(clearView)
        }

        stackView.addArrangedSubview(views)
        bottomStackViewConstraint.constant = isLast ? 0 : 16
    }
}
