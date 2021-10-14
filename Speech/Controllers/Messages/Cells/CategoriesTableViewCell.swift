//
//  MessageCollectionViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 25/05/2021.
//

import UIKit
import RxSwift
import RxGesture

class CategoriesTableViewCell: AbstractTableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var leadingStackViewConstraint: NSLayoutConstraint! {
        didSet {
            updateMargin(leadingStackViewConstraint)
        }
    }
    @IBOutlet weak var trailingStackViewConstraint: NSLayoutConstraint! {
        didSet {
            updateMargin(trailingStackViewConstraint)
        }
    }
    @IBOutlet weak var bottomStackViewConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var tapDisposables = [Disposable]()
    private(set) var categoriesView = [UIView]()
    var onCategoryTap: ((Category) -> Void)?
    
    // MARK: - Configure
    func configure(categories: [Category], column: Int, isLast: Bool, onConfigure: ((CategoryContentView, Category) -> Void)?) {
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        tapDisposables.removeAll()
        stackView.removeAllArrangedSubviews()
        
        categoriesView = categories.map { category -> UIView in
            let view: CategoryContentView = .loadFromXib()
            view.configure(category: category)
            onConfigure?(view, category)
            
            let tapDisposable = view.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.onCategoryTap?(category)
                })
            tapDisposables.append(tapDisposable)
            
            return view
        }
        
        let missingColumn = column - categoriesView.count
        for _ in 0..<missingColumn {
            let clearView = UIView()
            categoriesView.append(clearView)
        }

        stackView.addArrangedSubview(categoriesView)
        bottomStackViewConstraint.constant = isLast ? 0 : 16
    }
    
    private func updateMargin(_ constraint: NSLayoutConstraint) {
        if #available(iOS 13, *) {
            
        } else {
            constraint.constant = 16
        }
    }
}
